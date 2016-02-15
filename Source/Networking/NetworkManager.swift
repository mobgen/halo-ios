//
//  HaloNetworkManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

//typealias CompletionHandler = (NSURLRequest?, NSHTTPURLResponse?, Halo.Result<AnyObject, NSError>) -> Void

private struct CachedTask<T> {
    
    var request: Halo.Request<T>!
    var handler: ((NSURLRequest?, NSHTTPURLResponse?, Halo.Result<T, NSError>) -> Void)!
    
    init(request: Halo.Request<T>, handler: (NSURLRequest?, NSHTTPURLResponse?, Halo.Result<T, NSError>) -> Void) {
        self.request = request
        self.handler = handler
    }
    
}

/// Custom network manager implementation that handles authentication failures automatically,
/// queuing the pending network operations to be re-issued after authentication
class NetworkManager: Alamofire.Manager {

    /// Singleton instance of the custom network manager
    static let instance = NetworkManager()

    var debug: Bool = false
    
    var credentials: Credentials?
    
    var numberOfRetries = 0
    
    /// Variable that flags whether the manager is currently refreshing the auth token
    private var isRefreshing = false

    /// Queue of pending network tasks to be restarted after a successful authentication
    private var cachedTasks: [Any] = []
    
    private init() {
        
        let sessionDelegate = Alamofire.Manager.SessionDelegate()
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders

        var disableSSLpinning = false

        let bundle = NSBundle.mainBundle()

        if let path = bundle.pathForResource("Halo", ofType: "plist") {

            if let data = NSDictionary(contentsOfFile: path) {
                disableSSLpinning = data[CoreConstants.disableSSLpinning] as? Bool ?? false
            }
        }

        var trustManager: ServerTrustPolicyManager?

        if !disableSSLpinning {
            if let bundle = NSBundle(identifier: "com.mobgen.HaloSDK") {

                let serverTrustPolicy = ServerTrustPolicy.PinCertificates(
                    certificates: ServerTrustPolicy.certificatesInBundle(bundle),
                    validateCertificateChain: true,
                    validateHost: true)

                trustManager = ServerTrustPolicyManager(policies: [
                    "halo-int.mobgen.com" : serverTrustPolicy,
                    "halo-qa.mobgen.com" : serverTrustPolicy,
                    "halo-stage.mobgen.com" : serverTrustPolicy,
                    "halo.mobgen.com" : serverTrustPolicy
                ])
            }
        }

        super.init(configuration: configuration,
            delegate: sessionDelegate,
            serverTrustPolicyManager: trustManager)

    }

    /**
    Start the request flow handling also a potential 401/403 response. The token will be obtained/refreshed
    and the request will continue.

    - parameter request:            Request to be performed
    - parameter completionHandler:  Closure to be executed after the request has succeeded
    */
    func startRequest<T>(request urlRequest: Halo.Request<T>,
        numberOfRetries: Int,
        completionHandler handler: (NSURLRequest?, NSHTTPURLResponse?, Halo.Result<T, NSError>) -> Void) -> Void {

        let cachedTask = CachedTask<T>(request: urlRequest, handler: handler)

        if (self.isRefreshing) {
            /// If the token is being obtained/refreshed, add the task to the queue and return
            self.cachedTasks.append(cachedTask)
            return
        }

        let request = self.request(urlRequest)
        
        if self.debug {
            debugPrint(request)
        }
        
        request.responseJSON { [weak self] response in
            
            if let strongSelf = self {

                if let resp = response.response {
                    if resp.statusCode == 403 || resp.statusCode == 401 {
                        /// If we get a 403/401, we add the task to the queue and try to get a valid token
                        strongSelf.cachedTasks.append(cachedTask)
                        strongSelf.refreshToken()
                        return
                    }
                }

                switch response.result {
                case .Success(let data):

                    if strongSelf.debug {
                        debugPrint(data)
                    }

                    handler(response.request, response.response, .Success(data as! T, false))

                case .Failure(let error):
                    NSLog("Error performing request: \(error.localizedDescription)")
                    
                    if numberOfRetries > 0 {
                        strongSelf.startRequest(request: urlRequest, numberOfRetries: numberOfRetries - 1, completionHandler: handler)
                        return
                    }

                    handler(response.request, response.response, .Failure(error))
                }
            }
        }
    }

    func startRequest<T>(request urlRequest: Halo.Request<T>,
        completionHandler handler: (NSURLRequest?, NSHTTPURLResponse?, Halo.Result<T, NSError>) -> Void) -> Void {

            self.startRequest(request: urlRequest, numberOfRetries: self.numberOfRetries, completionHandler: handler)

    }
    
    /**
    Obtain/refresh an authentication token when needed
    */
    func refreshToken(completionHandler handler: ((NSURLRequest?, NSHTTPURLResponse?, Halo.Result<[String: AnyObject], NSError>) -> Void)? = nil) -> Void {
        self.isRefreshing = true

        var params: [String: AnyObject]
        
        if let cred = self.credentials {
            
            if let token = Router.token {
                
                params = [
                    "grant_type"    : "refresh_token",
                    "refresh_token" : token.refreshToken!
                ]
                
                switch cred.type {
                case .App:
                    params["client_id"] = cred.username
                    params["client_secret"] = cred.password
                case .User:
                    params["username"] = cred.username
                    params["password"] = cred.password
                }
                
            } else {
                
                switch cred.type {
                case .App:
                    params = [
                        "grant_type" : "client_credentials",
                        "client_id" : cred.username,
                        "client_secret" : cred.password
                    ]
                case .User:
                    params = [
                        "grant_type" : "password",
                        "username" : cred.username,
                        "password" : cred.password
                    ]
                }
            }

            Halo.Request<[String: AnyObject]>(router: Router.OAuth(cred, params)).response(completionHandler: { (request, response, result) -> Void in
                switch result {
                case .Success(let value, let cached):

                    Router.token = nil

                    if let resp = response {
                        if resp.statusCode == 200 {
                            Router.token = Token(value)
                        } else {
                            NSLog("Error retrieving token")
                        }
                    } else {
                        // No response
                        NSLog("No response from server")
                    }

                    handler?(request, response, .Success(value, cached))

                case .Failure(let error):
                    NSLog("Error refreshing token: \(error.localizedDescription)")

                    handler?(request, response, .Failure(error))
                }

                self.isRefreshing = false

                /// Restart cached tasks
                let cachedTasksCopy = self.cachedTasks
                self.cachedTasks.removeAll()
                let _ = cachedTasksCopy.map({ (t) -> Void in
                    let task = t as! CachedTask<Any>
                    self.startRequest(request: task.request, numberOfRetries: self.numberOfRetries, completionHandler: task.handler)
                })
            })

        }
    }
}
