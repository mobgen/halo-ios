//
//  HaloNetworkManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

//typealias CompletionHandler = (Alamofire.Response) -> Void
typealias CompletionHandler = (NSURLRequest?, NSHTTPURLResponse?, Result<AnyObject, NSError>) -> Void

private struct CachedTask {
    
    var request: URLRequestConvertible!
    var handler: CompletionHandler!
    
    init(request: URLRequestConvertible, handler: CompletionHandler) {
        self.request = request
        self.handler = handler
    }
    
}

/// Custom network manager implementation that handles authentication failures automatically,
/// queuing the pending network operations to be re-issued after authentication
class NetworkManager: Alamofire.Manager {

    /// Singleton instance of the custom network manager
    static let instance = NetworkManager()

    var credentials: Credentials? {
        didSet {
            Router.token = nil
            self.refreshToken()
        }
    }
    
    /// Variable that flags whether the manager is currently refreshing the auth token
    private var isRefreshing = false

    /// Queue of pending network tasks to be restarted after a successful authentication
    private var cachedTasks = Array<CachedTask>()
    
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
    func startRequest(request: URLRequestConvertible, completionHandler handler: CompletionHandler) -> Void {

        let cachedTask = CachedTask(request: request, handler: handler)

        if (self.isRefreshing) {
            /// If the token is being obtained/refreshed, add the task to the queue and return
            self.cachedTasks.append(cachedTask)
            return
        }

        let request = self.request(request)

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
            }

            handler(response.request, response.response, response.result)
        }
    }

    /**
    Obtain/refresh an authentication token when needed
    */
    func refreshToken(completionHandler: CompletionHandler? = nil) -> Void {
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
            
            self.request(Router.OAuth(cred, params)).responseJSON { response in
                switch response.result {
                case .Success(let value):
                    let dict = value as! Dictionary<String, AnyObject>
                    
                    Router.token = nil
                    
                    if let resp = response.response {
                        if resp.statusCode == 200 {
                            Router.token = Token(dict)
                        } else {
                            NSLog("Error retrieving token")
                        }
                    } else {
                        // No response
                        NSLog("No response from server")
                    }
                    
                case .Failure(let error):
                    NSLog("Error refreshing token: \(error.localizedDescription)")
                }
                
                self.isRefreshing = false
                
                /// Restart cached tasks
                let cachedTaskCopy = self.cachedTasks
                self.cachedTasks.removeAll()
                let _ = cachedTaskCopy.map { self.startRequest($0.request, completionHandler: $0.handler) }
                
                completionHandler?(response.request, response.response, response.result)
            }
        }
    }
}
