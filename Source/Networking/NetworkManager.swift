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

@objc public enum AuthenticationMode: Int {
    case App, User
}

class NetworkManager: NSObject, HaloManager, NSURLSessionDelegate {

    var debug: Bool = false

    var authenticationMode: AuthenticationMode = .App {
        didSet {
            Router.token = nil
        }
    }
    
    var credentials: Credentials? {
        switch self.authenticationMode {
        case .App: return self.appCredentials
        case .User: return self.userCredentials
        }
    }

    var appCredentials: Credentials?

    var userCredentials: Credentials?
    
    var numberOfRetries = 0
    
    private var isRefreshing = false
    
    private var enableSSLpinning = true
    
    private var cachedTasks = [CachedTask]()
    
    private var session: NSURLSession!
    
    private let unauthorizedResponseCodes = [401, 403]
    
    private let errorResponseCodes = [404, 500]
    
    override init() {
        super.init()
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    }
    
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

            if self.debug {
                debugPrint(urlRequest)
            }

            session.dataTaskWithRequest(urlRequest.URLRequest) { (data, response, error) -> Void in
                
                if let resp = response as? NSHTTPURLResponse {
                    
                    if self.unauthorizedResponseCodes.contains(resp.statusCode) {
                        self.cachedTasks.append(cachedTask)
                        self.refreshToken()
                        return
                    }
                    
                    if resp.statusCode > 399 {
                        if numberOfRetries > 0 {
                            self.startRequest(request: urlRequest, numberOfRetries: numberOfRetries - 1)
                        } else {
                            var message : NSString
                            
                            do {
                                var error = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String : AnyObject]
                                error = error["error"] as! [String : AnyObject]
                                
                                message = error["message"] as? String ?? "An error has occurred"
                                
                            } catch {
                                message = "The content of the response is not a valid JSON"
                            }
                            
                            handler?(resp, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey : message])))
                        }
                    } else if let d = data {
                        handler?(resp, .Success(d, false))
                    } else {
                        handler?(resp, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
                    }
                } else {
                    handler?(nil, .Failure(NSError(domain: "com.mobgen.halo", code: -1009, userInfo: [NSLocalizedDescriptionKey : "No response received from server"])))
                }
            }.resume()

    }

    func startRequest(request urlRequest: Halo.Request,
        completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<NSData, NSError>) -> Void)? = nil) -> Void {

            self.startRequest(request: urlRequest, numberOfRetries: Manager.core.numberOfRetries, completionHandler: handler)

    }

    /**
     Obtain/refresh an authentication token when needed
     */
    func refreshToken(completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<Halo.Token, NSError>) -> Void)? = nil) -> Void {
        
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
            
            let req = Halo.Request(router: Router.OAuth(cred, params))

            if self.debug {
                debugPrint(req)
            }

            self.session.dataTaskWithRequest(req.URLRequest, completionHandler: { (data, response, error) -> Void in
            
                if let resp = response as? NSHTTPURLResponse {
                    
                    if resp.statusCode > 399 {
//                    if let e = error {
                        
                        handler?(resp, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
                        
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
            }).resume()
            
        } else {
            NSLog("No credentials found")
        }
    }

    // MARK: SSL Pinning

    func evaluateServerTrust(serverTrust: SecTrust, isValidForHost host: String) -> Bool {
        let policy = SecPolicyCreateSSL(true, host as CFString)
        SecTrustSetPolicies(serverTrust, [policy])

        SecTrustSetAnchorCertificates(serverTrust, certificatesInBundle(NSBundle(identifier: "com.mobgen.HaloSDK")!))
        SecTrustSetAnchorCertificatesOnly(serverTrust, true)

        return trustIsValid(serverTrust)
    }


    private func certificatesInBundle(bundle: NSBundle = NSBundle.mainBundle()) -> [SecCertificate] {
        var certificates: [SecCertificate] = []

        let paths = Set([".cer", ".CER", ".crt", ".CRT", ".der", ".DER"].map { fileExtension in
            bundle.pathsForResourcesOfType(fileExtension, inDirectory: nil)
            }.flatten())

        for path in paths {
            if let
                certificateData = NSData(contentsOfFile: path),
                certificate = SecCertificateCreateWithData(nil, certificateData)
            {
                certificates.append(certificate)
            }
        }

        return certificates
    }

    private func trustIsValid(trust: SecTrust) -> Bool {
        var isValid = false

        var result = SecTrustResultType(kSecTrustResultInvalid)
        let status = SecTrustEvaluate(trust, &result)

        if status == errSecSuccess {
            let unspecified = SecTrustResultType(kSecTrustResultUnspecified)
            let proceed = SecTrustResultType(kSecTrustResultProceed)

            isValid = result == unspecified || result == proceed
        }
        
        return isValid
    }

    // MARK: NSURLSessionDelegate implementation

    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
        var credential: NSURLCredential?

        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let host = challenge.protectionSpace.host

            if let serverTrust = challenge.protectionSpace.serverTrust {
                if !self.enableSSLpinning || evaluateServerTrust(serverTrust, isValidForHost: host) {
                    disposition = .UseCredential
                    credential = NSURLCredential(forTrust: serverTrust)
                } else {
                    disposition = .CancelAuthenticationChallenge
                }
            }
        }

        completionHandler(disposition, credential)
    }

}
