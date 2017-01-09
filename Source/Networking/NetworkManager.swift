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

open class NetworkManager: NSObject, HaloManager, URLSessionDelegate {

    fileprivate var isRefreshing = false

    fileprivate var enableSSLpinning = true

    fileprivate var cachedTasks = [CachedTask]()

    fileprivate var session: Foundation.URLSession!

    fileprivate let unauthorizedResponseCodes = [401]

    fileprivate var addons: [Halo.NetworkAddon] = []

    override init() {
        super.init()
        let sessionConfig = URLSessionConfiguration.default
        self.session = Foundation.URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    }

    @objc(registerAddon:)
    open func registerAddon(addon: Halo.NetworkAddon) -> Void {
        self.addons.append(addon)
    }

    fileprivate func getCredentials(mode: Halo.AuthenticationMode = .app) -> Halo.Credentials? {
        switch mode {
        case .app:
            return Manager.core.appCredentials
        case .user:
            return Manager.core.userCredentials
        }
    }

    @objc(startup:)
    open func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {

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

        let cachedTask = CachedTask(request: urlRequest, retries: numberOfRetries, handler: handler)

        if (self.isRefreshing) {
            /// If the token is being obtained/refreshed, add the task to the queue and return
            self.cachedTasks.append(cachedTask)
            return
        }

        let request = urlRequest.URLRequest as URLRequest

        self.addons.forEach { $0.willPerformRequest(request: request) }

        let start = Date()
        var elapsed: TimeInterval = 0

        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            elapsed = Date().timeIntervalSince(start) * 1000
            
            if let resp = response as? HTTPURLResponse {
                
                LogMessage(message: "\(urlRequest) [\(elapsed)ms]", level: .info).print()
                
                if self.unauthorizedResponseCodes.contains(resp.statusCode) {
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
                        self.startRequest(request: urlRequest, numberOfRetries: numberOfRetries - 1)
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
                            handler?(resp, .failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey : message])))
                        }
                        
                    }
                } else if let d = data {
                    DispatchQueue.main.async {
                        handler?(resp, .success(d, false))
                    }
                } else {
                    DispatchQueue.main.async {
                        handler?(resp, .failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    handler?(nil, .failure(NSError(domain: "com.mobgen.halo", code: -1009, userInfo: [NSLocalizedDescriptionKey : "No response received from server"])))
                }
            }
            
            self.addons.forEach { $0.didPerformRequest(request: request, time: elapsed, response: response) }
            
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
        var params: [String : AnyObject]

        if let cred = getCredentials(mode: mode) {

            var tok: Token?

            switch cred.type {
            case .app:
                tok = Router.appToken
            case .user:
                tok = Router.userToken
            }

            if let token = tok {

                params = [
                    "grant_type"    : "refresh_token" as AnyObject,
                    "refresh_token" : token.refreshToken! as AnyObject
                ]

                switch cred.type {
                case .app:
                    params["client_id"] = cred.username as AnyObject?
                    params["client_secret"] = cred.password as AnyObject?
                case .user:
                    params["username"] = cred.username as AnyObject?
                    params["password"] = cred.password as AnyObject?
                }

            } else {

                switch cred.type {
                case .app:
                    params = [
                        "grant_type" : "client_credentials" as AnyObject,
                        "client_id" : cred.username as AnyObject,
                        "client_secret" : cred.password as AnyObject
                    ]
                case .user:
                    params = [
                        "grant_type" : "password" as AnyObject,
                        "username" : cred.username as AnyObject,
                        "password" : cred.password as AnyObject
                    ]
                }
            }

            let req = Halo.Request<Any>(router: Router.oAuth(cred, params)).authenticationMode(mode: mode)

            let start = Date()

            let task = self.session.dataTask(with: req.URLRequest) { (data, response, error) -> Void in

                if let resp = response as? HTTPURLResponse {

                    let elapsed = Date().timeIntervalSince(start) * 1000
                    LogMessage(message: "\(req.debugDescription) [\(elapsed)ms]", level: .info).print()

                    if resp.statusCode > 399 {

                        DispatchQueue.main.async {
                            handler?(resp, .failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
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
                        }

                        DispatchQueue.main.async {
                            handler?(resp, .success(token, false))
                        }

                        self.isRefreshing = false
                        
                        // Restart cached tasks
                        let cachedTasksCopy = self.cachedTasks
                        self.cachedTasks.removeAll()
                        cachedTasksCopy.forEach { task in
                            self.startRequest(request: task.request, numberOfRetries: task.numberOfRetries, completionHandler: task.handler)
                        }
                    }
                }
            }

            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                task.resume()
            }

        } else {
            LogMessage(message: "No credentials found", level: .error).print()
            handler?(nil, .failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
        }
    }

    // MARK: SSL Pinning

    func evaluateServerTrust(serverTrust: SecTrust, isValidForHost host: String) -> Bool {
        let policy = SecPolicyCreateSSL(true, host as CFString)
        SecTrustSetPolicies(serverTrust, [policy] as AnyObject)

        SecTrustSetAnchorCertificates(serverTrust, certificatesInBundle(bundle: Bundle(identifier: "com.mobgen.Halo")!) as CFArray)
        SecTrustSetAnchorCertificatesOnly(serverTrust, true)

        return trustIsValid(trust: serverTrust)
    }


    fileprivate func certificatesInBundle(bundle: Bundle = Bundle.main) -> [SecCertificate] {
        var certificates: [SecCertificate] = []

        let paths = Set([".cer", ".CER", ".crt", ".CRT", ".der", ".DER"].map { fileExtension in
            bundle.paths(forResourcesOfType: fileExtension, inDirectory: nil)
            }.joined())

        for path in paths {
            if let
                certificateData = try? Data(contentsOf: URL(fileURLWithPath: path)),
                let certificate = SecCertificateCreateWithData(nil, certificateData as CFData) {
                certificates.append(certificate)
            }
        }

        return certificates
    }

    fileprivate func trustIsValid(trust: SecTrust) -> Bool {
        var isValid = false

        var result = SecTrustResultType.invalid
        let status = SecTrustEvaluate(trust, &result)

        if status == errSecSuccess {
            let unspecified = SecTrustResultType.unspecified
            let proceed = SecTrustResultType.proceed

            isValid = result == unspecified || result == proceed
        }

        return isValid
    }

    // MARK: NSURLSessionDelegate implementation
    
    open func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var disposition: Foundation.URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?

        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let host = challenge.protectionSpace.host

            if let serverTrust = challenge.protectionSpace.serverTrust {
                if !self.enableSSLpinning || evaluateServerTrust(serverTrust: serverTrust, isValidForHost: host) {
                    disposition = .useCredential
                    credential = URLCredential(trust: serverTrust)
                } else {
                    disposition = .cancelAuthenticationChallenge
                }
            }
        }

        completionHandler(disposition, credential)
    }

}
