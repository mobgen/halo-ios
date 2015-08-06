//
//  HaloNetworkManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

/// Custom network manager implementation that handles authentication failures automatically,
/// queuing the pending network operations to be re-issued after authentication
class NetworkManager: Alamofire.Manager {

    /// Singleton instance of the custom network manager
    static let instance = NetworkManager()

    /// Client id that identifies the client in the requests agains the API endpoints
    var clientId: String?

    /// Corresponding client secret to be provided for the API calls
    var clientSecret: String?

    typealias CompletionHandler = (NSURLRequest?, NSHTTPURLResponse?, Result<AnyObject>) -> Void
    private typealias CachedTask = (NSURLRequest?, NSHTTPURLResponse?, Result<AnyObject>) -> Void

    /// Variable that flags whether the manager is currently refreshing the auth token
    private var isRefreshing = false

    /// Queue of pending network tasks to be restarted after a successful authentication
    private var cachedTasks = Array<CachedTask>()

    private init() {}

    required init(configuration: NSURLSessionConfiguration, serverTrustPolicyManager: ServerTrustPolicyManager?) {
        fatalError("init(configuration:serverTrustPolicyManager:) has not been implemented")
    }

    /**
    Start the request flow handling also a potential 401 response. The token will be obtained/refreshed
    and the request will continue.

    - parameter request:            Request to be performed
    - parameter completionHandler:  Closure to be executed after the request has succeeded
    */
    func startRequest(request: URLRequestConvertible, completionHandler handler: CompletionHandler) -> Void {

        let cachedTask: CachedTask = { [weak self] urlRequest, urlResponse, result in
            if let strongSelf = self {
                switch result {
                case .Success(_):
                    strongSelf.startRequest(request, completionHandler: handler)
                case .Failure(_, _):
                    handler(urlRequest, urlResponse, result)
                }

            }
        }

        if (self.isRefreshing) {
            /// If the token is being obtained/refreshed, add the task to the queue and return
            self.cachedTasks.append(cachedTask)
            return
        }

        let request = self.request(request)

        print(request)

        request.responseJSON { [weak self] (request, response, result) -> Void in
            if let strongSelf = self {
                if let resp = response {
                    if resp.statusCode == 401 {
                        /// If we get a 401, we add the task to the queue and try to get a valid token
                        strongSelf.cachedTasks.append(cachedTask)
                        strongSelf.refreshToken()
                        return
                    }
                }
            }

            handler(request, response, result)
        }
    }

    /**
    Obtain/refresh an authentication token when needed
    */
    private func refreshToken() -> Void {
        self.isRefreshing = true

        let params: Dictionary<String, AnyObject>

        if let token = Router.token {
            params = [
                "grant_type" : "refresh_token",
                "client_id" : clientId!,
                "client_secret" : clientSecret!,
                "refresh_token" : token.refreshToken!
            ]
        } else {
            params = [
                "grant_type" : "client_credentials",
                "client_id" : clientId!,
                "client_secret" : clientSecret!
            ]
        }

        self.request(Router.OAuth(params)).responseJSON { (req, resp, result) -> Void in
            switch result {
            case .Success(let value):
                let dict = value as! Dictionary<String, AnyObject>

                Router.token = nil
                let res: Alamofire.Result<AnyObject>

                if let response = resp {
                    if response.statusCode == 200 {
                        Router.token = Token(dict)
                        res = result
                    } else {
                        res = .Failure(nil, NSError(domain: "com.mobgen.halo", code: 0, userInfo: [NSLocalizedDescriptionKey : "Error retrieving token"]))
                    }
                } else {
                    // No response
                    res = .Failure(nil, NSError(domain: "com.mobgen.halo", code: 0, userInfo: [NSLocalizedDescriptionKey : "No response from server"]))
                }

                /// Restart cached tasks
                let cachedTaskCopy = self.cachedTasks
                self.cachedTasks.removeAll()
                cachedTaskCopy.map { $0(nil, nil, res) }

            case .Failure(_, let error):
                print("Error refreshing token: \(error.localizedDescription)")
            }
        }

        self.isRefreshing = false
    }
}
