//
//  HaloNetworkManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

private struct CachedTask {
    
    var request: Halo.Request
    var numberOfRetries: Int
    var handler: ((NSHTTPURLResponse?, Halo.Result<NSData, NSError>) -> Void)?
    
    init(request: Halo.Request, retries: Int, handler: ((NSHTTPURLResponse?, Halo.Result<NSData, NSError>) -> Void)?) {
        self.request = request
        self.numberOfRetries = retries
        self.handler = handler
    }
    
}

class NetworkManager: HaloManager {

    var debug: Bool = false
    
    var credentials: Credentials?
    
    var numberOfRetries = 0
    
    private var isRefreshing = false
    
    private var enableSSLpinning = false
    
    private var cachedTasks = [CachedTask]()
    
    private let session = NSURLSession.sharedSession()
    
    private let responseCodes = [401, 403]
    
    init() {}
    
    func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {
        
        let bundle = NSBundle.mainBundle()
        
        if let path = bundle.pathForResource("Halo", ofType: "plist") {
            
            if let data = NSDictionary(contentsOfFile: path) {
                let disable = data[CoreConstants.disableSSLpinning] as? Bool ?? true
                self.enableSSLpinning = !disable
            }
        }
        
        handler?(true)
    }
    
    func startRequest(request urlRequest: Halo.Request,
        numberOfRetries: Int,
        completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<NSData, NSError>) -> Void)? = nil) -> Void {
            
            let cachedTask = CachedTask(request: urlRequest, retries: numberOfRetries, handler: handler)
            
            if (self.isRefreshing) {
                /// If the token is being obtained/refreshed, add the task to the queue and return
                self.cachedTasks.append(cachedTask)
                return
            }
            
            let dataTask = session.dataTaskWithRequest(urlRequest.URLRequest) { (data, response, error) -> Void in
                
                if let resp = response as? NSHTTPURLResponse {
                    
                    if self.responseCodes.contains(resp.statusCode) {
                        self.cachedTasks.append(cachedTask)
                        self.refreshToken()
                        return
                    }
                    
                    if let e = error {
                        if numberOfRetries > 0 {
                            self.startRequest(request: urlRequest, numberOfRetries: numberOfRetries - 1)
                        } else {
                            handler?(resp, .Failure(e))
                        }
                    } else if let d = data {
                        handler?(resp, .Success(d, false))
                    } else {
                        handler?(resp, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
                    }
                } else {
                    
                }
            }
            
            if self.debug {
                debugPrint(urlRequest)
            }
            
            dataTask.resume()
    }

    func startRequest(request urlRequest: Halo.Request,
        completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<NSData, NSError>) -> Void)? = nil) -> Void {

            self.startRequest(request: urlRequest, numberOfRetries: Manager.core.numberOfRetries, completionHandler: handler)

    }

    /**
     Obtain/refresh an authentication token when needed
     */
    private func refreshToken(completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<Halo.Token, NSError>) -> Void)? = nil) -> Void {
        
        self.isRefreshing = true
        var params: [String : AnyObject]
        
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
            
            let req = Halo.Request(router: Router.OAuth(cred, params)).URLRequest
            
            self.session.dataTaskWithRequest(req, completionHandler: { (data, response, error) -> Void in
            
                if let resp = response as? NSHTTPURLResponse {
                    
                    if let e = error {
                        
                        handler?(resp, .Failure(e))
                        
                    } else if let d = data {
                        
                        let json = try! NSJSONSerialization.JSONObjectWithData(d, options: []) as! [String : AnyObject]
                        let token = Token(json)
                        
                        Router.token = token
                        handler?(resp, .Success(token, false))
                    }
                    
                    self.isRefreshing = false
                    
                    // Restart cached tasks
                    let cachedTasksCopy = self.cachedTasks
                    self.cachedTasks.removeAll()
                    let _ = cachedTasksCopy.map({ (task) -> Void in
                        self.startRequest(request: task.request, numberOfRetries: task.numberOfRetries, completionHandler: task.handler)
                    })
                }
            })
            
        } else {
            NSLog("No credentials found")
        }
    }
}
