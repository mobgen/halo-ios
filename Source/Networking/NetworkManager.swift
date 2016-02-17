//
//  HaloNetworkManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire
import then

//typealias CompletionHandler = (NSURLRequest?, NSHTTPURLResponse?, Halo.Result<AnyObject, NSError>) -> Void

private struct CachedTask {
    
    var request: Halo.Request!
    var numberOfRetries: Int
    var handler: ((NSURLRequest?, NSHTTPURLResponse?, Halo.Result<AnyObject, NSError>) -> Void)?
    
    init(request: Halo.Request, retries: Int, handler: ((NSURLRequest?, NSHTTPURLResponse?, Halo.Result<AnyObject, NSError>) -> Void)?) {
        self.request = request
        self.numberOfRetries = retries
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
    private var cachedTasks: [CachedTask] = []
    
    private init() {
        
        let sessionDelegate = Alamofire.Manager.SessionDelegate()
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders

        var enableSSLpinning = false

        let bundle = NSBundle.mainBundle()

        if let path = bundle.pathForResource("Halo", ofType: "plist") {

            if let data = NSDictionary(contentsOfFile: path) {
                let disable = data[CoreConstants.disableSSLpinning] as? Bool ?? true
                enableSSLpinning = !disable
            }
        }

        var trustManager: ServerTrustPolicyManager?

        if enableSSLpinning {
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
    func startRequest(request urlRequest: Halo.Request,
        numberOfRetries: Int,
        completionHandler handler: ((NSURLRequest?, NSHTTPURLResponse?, Halo.Result<AnyObject, NSError>) -> Void)? = nil) -> Void {

        let cachedTask = CachedTask(request: urlRequest, retries: numberOfRetries, handler: handler)

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

                    handler?(response.request, response.response, .Success(data, false))

                case .Failure(let error):
                    NSLog("Error performing request: \(error.localizedDescription)")
                    
                    if numberOfRetries > 0 {
                        strongSelf.startRequest(request: urlRequest, numberOfRetries: numberOfRetries - 1, completionHandler: handler)
                        return
                    }

                    handler?(response.request, response.response, .Failure(error))
                }
            }
        }
    }

    func startRequest(request urlRequest: Halo.Request,
        completionHandler handler: ((NSURLRequest?, NSHTTPURLResponse?, Halo.Result<AnyObject, NSError>) -> Void)? = nil) -> Void {

            self.startRequest(request: urlRequest, numberOfRetries: self.numberOfRetries, completionHandler: handler)

    }
    
    /**
    Obtain/refresh an authentication token when needed
    */
    private func refreshToken(completionHandler handler: ((NSURLRequest?, NSHTTPURLResponse?, Halo.Result<Halo.Token, NSError>) -> Void)? = nil) -> Void {
        
        self.isRefreshing = true
        var params: [String:AnyObject]
        
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

            let req = self.request(Halo.Request(router: Router.OAuth(cred, params)))
            
            req.responseJSON(completionHandler: { (resp) -> Void in
                switch resp.result {
                case .Success(let data as [String:AnyObject]):
                    
                    Router.token = nil
                    
                    if let r = resp.response {
                        if r.statusCode == 200 {
                            NSLog("New token retrieved")
                            Router.token = Token(data)
                            handler?(resp.request, resp.response, .Success(Router.token!, false))
                        } else {
                            NSLog("Error retrieving token")
                            handler?(resp.request, resp.response, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
                        }
                    } else {
                        // No response
                        NSLog("No response from server")
                        handler?(resp.request, resp.response, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
                    }
                    
                case .Failure(let error):
                    NSLog("Error refreshing token: \(error.localizedDescription)")
                    handler?(resp.request, resp.response, .Failure(error))
                default:
                    break
                }
                
                self.isRefreshing = false
                
                /// Restart cached tasks
                let cachedTasksCopy = self.cachedTasks
                self.cachedTasks.removeAll()
                let _ = cachedTasksCopy.map({ (task) -> Void in
                    self.startRequest(request: task.request, numberOfRetries: task.numberOfRetries, completionHandler: task.handler)
                })
            })
            
        } else {
            NSLog("No credentials found")
        }
    }
}
