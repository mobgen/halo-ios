//
//  HaloNetworkManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

private struct CachedTask {

    var request: Halo.Requestable
    var numberOfRetries: Int
    var handler: ((HTTPURLResponse?, Halo.Result<Data>) -> Void)?

    init(request: Halo.Requestable, retries: Int, handler: ((HTTPURLResponse?, Halo.Result<Data>) -> Void)?) {
        self.request = request
        self.numberOfRetries = retries
        self.handler = handler
    }

}

@objc(HaloNetworkManager)
open class NetworkManager: NSObject, HaloManager {

    public static var timeoutIntervalForRequest: TimeInterval?
    public static var timeoutIntervalForResource: TimeInterval?
    
    var isRefreshing = false

    var enableSSLpinning = true

    fileprivate var cachedTasks = [CachedTask]()

    var session: Foundation.URLSession!

    let unauthorizedResponseCodes = [401]

    var addons: [Halo.NetworkAddon] = []

    fileprivate override init() {
        super.init()
        let sessionConfig = URLSessionConfiguration.default
        
        if let requestTimeout = NetworkManager.timeoutIntervalForRequest {
            sessionConfig.timeoutIntervalForRequest = requestTimeout
        }
        
        if let resourceTimeout = NetworkManager.timeoutIntervalForResource {
            sessionConfig.timeoutIntervalForResource = resourceTimeout
        }
        
        self.session = Foundation.URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    }

    @objc(registerAddon:)
    open func registerAddon(addon: Halo.NetworkAddon) -> Void {
        self.addons.append(addon)
    }

    fileprivate func getCredentials(mode: Halo.AuthenticationMode = Manager.core.defaultAuthenticationMode) -> Halo.Credentials? {
        switch mode {
        case .app:
            return Manager.core.appCredentials
        case .user:
            return Manager.core.userCredentials
        default:
            return nil
        }
    }

    @objc(startup:)
    open func startup(_ handler: ((Bool) -> Void)?) -> Void {

        let bundle = Bundle.main

        if let path = bundle.path(forResource: Manager.core.configuration, ofType: "plist") {

            if let data = NSDictionary(contentsOfFile: path) {
                let disable = data[CoreConstants.disableSSLpinning] as? Bool ?? false
                self.enableSSLpinning = !disable
            }
        }

        handler?(true)
    }

    func startRequest(request urlRequest: Requestable,
                              numberOfRetries: Int,
                              completionHandler handler: ((HTTPURLResponse?, Halo.Result<Data>) -> Void)? = nil) -> Void {

        
        
        if (self.isRefreshing || (!Halo.Manager.core.isReady && !urlRequest.bypassReadiness)) {
            /// If the token is being obtained/refreshed, add the task to the queue and return
            let cachedTask = CachedTask(request: urlRequest, retries: numberOfRetries, handler: handler)
            
            self.cachedTasks.append(cachedTask)
            return
        }

        let request = urlRequest.urlRequest

        self.addons.forEach { $0.willPerformRequest(request) }

        let start = Date()
        var elapsed: TimeInterval = 0

        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            elapsed = Date().timeIntervalSince(start) * 1000
            
            if let resp = response as? HTTPURLResponse {
                
                Manager.core.logMessage("\(urlRequest) [\(elapsed)ms]", level: .info)
                Manager.core.logMessage("Response object: \(resp.debugDescription)", level: .info)
                
                if self.unauthorizedResponseCodes.contains(resp.statusCode) {
                    let cachedTask = CachedTask(request: urlRequest, retries: numberOfRetries, handler: handler)
                    
                    self.cachedTasks.append(cachedTask)
                    self.authenticate(mode: urlRequest.authenticationMode) { response, result in
                        
                        switch result {
                        case .failure(let error):
                            handler?(resp, .failure(error))
                        default:
                            break
                        }
                    }
                    return
                }
                
                if resp.statusCode > 399 {
                    if numberOfRetries > 0 {
                        self.startRequest(request: urlRequest, numberOfRetries: numberOfRetries - 1, completionHandler: handler)
                    } else {
                        var message: String
                        
                        do {
                            var error = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                            error = error["error"] as! [String : AnyObject]
                            
                            message = error["message"] as? String ?? "An error has occurred"
                            
                        } catch {
                            message = "The content of the response is not a valid JSON"
                        }
                        
                        DispatchQueue.main.async {
                            handler?(resp, .failure(.parsingError(message)))
                        }
                        
                    }
                } else if let d = data {
                    DispatchQueue.main.async {
                        handler?(resp, .success(d, false))
                    }
                } else {
                    DispatchQueue.main.async {
                        handler?(resp, .failure(.noDataReceived))
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    handler?(nil, .failure(.noResponseReceived))
                }
            }
            
            self.addons.forEach { $0.didPerformRequest(request, time: elapsed, response: response) }
            
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            task.resume()
        }

    }

    func startRequest(request urlRequest: Requestable,
                              completionHandler handler: ((HTTPURLResponse?, Halo.Result<Data>) -> Void)? = nil) -> Void {

        self.startRequest(request: urlRequest, numberOfRetries: urlRequest.numberOfRetries ?? Manager.core.numberOfRetries, completionHandler: handler)
    }

    /**
     Obtain/refresh an authentication token when needed
     */
    func authenticate(mode: Halo.AuthenticationMode, completionHandler handler: ((HTTPURLResponse?, Halo.Result<Halo.Token>) -> Void)? = nil) -> Void {

        self.isRefreshing = true
        var params: [String: Any]
        var task: URLSessionDataTask
        
        switch mode {
            
        case .appPlus:
            if let profile = AuthProfile.loadProfile() {
                
                let req = Halo.Request<User>(router: Router.loginUser(profile.toDictionary()), bypassReadiness: true).authenticationMode(mode)
                
                let start = Date()
                
                task = self.session.dataTask(with: req.urlRequest) { (data, response, error) in
                    
                    if let resp = response as? HTTPURLResponse {
                        
                        let elapsed = Date().timeIntervalSince(start) * 1000
                        Manager.core.logMessage("\(req.debugDescription) [\(elapsed)ms]", level: .info)
                        
                        if resp.statusCode > 399 {
                            
                            DispatchQueue.main.async {
                                handler?(resp, .failure(.errorResponse(resp.statusCode)))
                            }
                            
                            self.cachedTasks.removeAll()
                            
                            self.isRefreshing = false
                            return
                            
                        } else if let d = data {
                            
                            let json = try! JSONSerialization.jsonObject(with: d, options: []) as! [String: Any]
                            
                            Manager.auth.currentUser = User.fromDictionary(json)
                            
                            DispatchQueue.main.async {
                                if let user = Manager.auth.currentUser {
                                    handler?(resp, .success(user.token, false))
                                } else {
                                    // No user? Fail
                                    handler?(resp, .failure(.loginError("No user returned from server")))
                                }
                            }
                            
                            self.isRefreshing = false
                            self.restartCachedTasks()
                        }
                    }
                }
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                    task.resume()
                }
                
            } else {
                self.isRefreshing = false
                Manager.core.logMessage("No credentials found", level: .error)
                handler?(nil, .failure(.noValidCredentialsFound))
            }
        case .app, .user:
            if let cred = getCredentials(mode: mode) {
                
                var tok: Token?
                
                switch cred.type {
                case .app:
                    tok = Router.appToken
                case .user:
                    tok = Router.userToken
                }
                
                if let token = tok, cred.type == .app {
                    
                    params = [
                        "grant_type"    : "refresh_token",
                        "refresh_token" : token.refreshToken!
                    ]
                    
                    params["client_id"] = cred.username
                    params["client_secret"] = cred.password
                    
                } else {
                    
                    switch cred.type {
                    case .app:
                        params = [
                            "grant_type" : "client_credentials",
                            "client_id" : cred.username,
                            "client_secret" : cred.password
                        ]
                    case .user:
                        params = [
                            "grant_type" : "password",
                            "username" : cred.username,
                            "password" : cred.password
                        ]
                    }
                }
                
                let req = Halo.Request<Any>(router: Router.oAuth(cred, params), bypassReadiness: true).authenticationMode(mode)
                
                let start = Date()
                
                let task = self.session.dataTask(with: req.urlRequest) { (data, response, error) -> Void in
                    
                    if let resp = response as? HTTPURLResponse {
                        
                        let elapsed = Date().timeIntervalSince(start) * 1000
                        Manager.core.logMessage("\(req.debugDescription) [\(elapsed)ms]", level: .info)
                        
                        if resp.statusCode > 399 {
                            
                            DispatchQueue.main.async {
                                handler?(resp, .failure(.errorResponse(resp.statusCode)))
                            }
                            
                            self.cachedTasks.removeAll()
                            
                            self.isRefreshing = false
                            return
                            
                        } else if let d = data {
                            
                            let json = try! JSONSerialization.jsonObject(with: d, options: []) as! [String : AnyObject]
                            let token = Token.fromDictionary(json)
                            
                            switch req.authenticationMode {
                            case .app:
                                Router.appToken = token
                            case .user:
                                Router.userToken = token
                            default:
                                break
                            }
                            
                            DispatchQueue.main.async {
                                handler?(resp, .success(token, false))
                            }
                            
                            self.isRefreshing = false
                            self.restartCachedTasks()
                        }
                    }
                }
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                    task.resume()
                }
                
            } else {
                self.isRefreshing = false
                Manager.core.logMessage("No credentials found", level: .error)
                handler?(nil, .failure(.noValidCredentialsFound))
            }
        }
    }
    
    func restartCachedTasks() {
        // Restart cached tasks
        Manager.core.logMessage("Restarting enqueued tasks...", level: .info)
        let cachedTasksCopy = self.cachedTasks
        self.cachedTasks.removeAll()
        cachedTasksCopy.forEach { self.startRequest(request: $0.request, numberOfRetries: $0.numberOfRetries, completionHandler: $0.handler) }
    }
    
    func clearCachedTasks() {
        self.cachedTasks.removeAll()
    }

}

public extension Manager {
    
    public static let network: NetworkManager = {
        return NetworkManager()
    }()
    
}
