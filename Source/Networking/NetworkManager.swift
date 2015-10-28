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

    /// Client id that identifies the client in the requests agains the API endpoints
    var clientId: String?

    /// Corresponding client secret to be provided for the API calls
    var clientSecret: String?
    
    /// Variable that flags whether the manager is currently refreshing the auth token
    private var isRefreshing = false

    /// Queue of pending network tasks to be restarted after a successful authentication
    private var cachedTasks = Array<CachedTask>()
    
    private init() {
        
        let sessionDelegate = Alamofire.Manager.SessionDelegate()
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
        
        var trustManager: ServerTrustPolicyManager?
        
        if let bundle = NSBundle(identifier: "com.mobgen.HaloSDK") {
            
            let serverTrustPolicy = ServerTrustPolicy.PinCertificates(
                certificates: ServerTrustPolicy.certificatesInBundle(bundle),
                validateCertificateChain: true,
                validateHost: true)
            
            trustManager = ServerTrustPolicyManager(policies: [
                "halo-int.mobgen.com" : serverTrustPolicy,
                "halo-qa.mobgen.com" : serverTrustPolicy,
                "halo-stage.mobgen.com" : serverTrustPolicy
                ])
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

        let params: Dictionary<String, AnyObject>

        if let token = Router.token {
            params = [
                "grant_type" : "refresh_token",
                "client_id" : self.clientId!,
                "client_secret" : self.clientSecret!,
                "refresh_token" : token.refreshToken!
            ]
        } else {
            params = [
                "grant_type" : "client_credentials",
                "client_id" : self.clientId!,
                "client_secret" : self.clientSecret!
            ]
        }

        self.request(Router.OAuth(params)).responseJSON { response in
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
