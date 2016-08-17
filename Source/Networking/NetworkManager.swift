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
    var handler: ((NSHTTPURLResponse?, Halo.Result<NSData, NSError>) -> Void)?

    init(request: Halo.Requestable, retries: Int, handler: ((NSHTTPURLResponse?, Halo.Result<NSData, NSError>) -> Void)?) {
        self.request = request
        self.numberOfRetries = retries
        self.handler = handler
    }

}

public class NetworkManager: NSObject, HaloManager, NSURLSessionDelegate {

    private var isRefreshing = false

    private var enableSSLpinning = true

    private var cachedTasks = [CachedTask]()

    private var session: NSURLSession!

    private let unauthorizedResponseCodes = [401]

    private var addons: [Halo.NetworkAddon] = []

    override init() {
        super.init()
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    }

    public func registerAddon(addon: Halo.NetworkAddon) -> Void {
        self.addons.append(addon)
    }

    private func getCredentials(mode: Halo.AuthenticationMode = .App) -> Halo.Credentials? {
        switch mode {
        case .App:
            return Manager.core.appCredentials
        case .User:
            return Manager.core.userCredentials
        }
    }

    public func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {

        let bundle = NSBundle.mainBundle()

        if let path = bundle.pathForResource(Manager.core.configuration, ofType: "plist") {

            if let data = NSDictionary(contentsOfFile: path) {
                let disable = data[CoreConstants.disableSSLpinning] as? Bool ?? true
                self.enableSSLpinning = !disable
            }
        }

        handler?(true)
    }

    func startRequest(request urlRequest: Requestable,
                              numberOfRetries: Int,
                              completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<NSData, NSError>) -> Void)? = nil) -> Void {

        let cachedTask = CachedTask(request: urlRequest, retries: numberOfRetries, handler: handler)

        if (self.isRefreshing) {
            /// If the token is being obtained/refreshed, add the task to the queue and return
            self.cachedTasks.append(cachedTask)
            return
        }

        let request = urlRequest.URLRequest

        let _ = self.addons.map { $0.willPerformRequest(request) }

        let start = NSDate()
        var elapsed: NSTimeInterval = 0

        session.dataTaskWithRequest(request) { (data, response, error) -> Void in

            elapsed = NSDate().timeIntervalSinceDate(start) * 1000

            if let resp = response as? NSHTTPURLResponse {

                LogMessage("\(urlRequest) [\(elapsed)ms]", level: .Info).print()

                if self.unauthorizedResponseCodes.contains(resp.statusCode) {
                    self.cachedTasks.append(cachedTask)
                    self.authenticate(urlRequest.authenticationMode)
                    return
                }

                if resp.statusCode > 399 {
                    if numberOfRetries > 0 {
                        self.startRequest(request: urlRequest, numberOfRetries: numberOfRetries - 1)
                    } else {
                        var message: NSString

                        do {
                            var error = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String : AnyObject]
                            error = error["error"] as! [String : AnyObject]

                            message = error["message"] as? String ?? "An error has occurred"

                        } catch {
                            message = "The content of the response is not a valid JSON"
                        }

                        dispatch_async(dispatch_get_main_queue(), {
                            handler?(resp, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey : message])))
                        })

                    }
                } else if let d = data {
                    dispatch_async(dispatch_get_main_queue(), {
                        handler?(resp, .Success(d, false))
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        handler?(resp, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
                    })
                }

            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    handler?(nil, .Failure(NSError(domain: "com.mobgen.halo", code: -1009, userInfo: [NSLocalizedDescriptionKey : "No response received from server"])))
                })
            }

            let _ = self.addons.map { $0.didPerformRequest(request, time: elapsed, response: response) }

            }.resume()

    }

    func startRequest(request urlRequest: Requestable,
                              completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<NSData, NSError>) -> Void)? = nil) -> Void {

        self.startRequest(request: urlRequest, numberOfRetries: Manager.core.dataProvider.numberOfRetries, completionHandler: handler)
    }

    /**
     Obtain/refresh an authentication token when needed
     */
    func authenticate(mode: Halo.AuthenticationMode, completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<Halo.Token, NSError>) -> Void)? = nil) -> Void {

        self.isRefreshing = true
        var params: [String : AnyObject]

        if let cred = getCredentials(mode) {

            var tok: Token?

            switch cred.type {
            case .App:
                tok = Router.appToken
            case .User:
                tok = Router.userToken
            }

            if let token = tok {

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

            let req = Halo.Request<Any>(router: Router.OAuth(cred, params)).authenticationMode(mode)

            let start = NSDate()

            self.session.dataTaskWithRequest(req.URLRequest, completionHandler: { (data, response, error) -> Void in

                if let resp = response as? NSHTTPURLResponse {

                    let elapsed = NSDate().timeIntervalSinceDate(start) * 1000
                    LogMessage("\(req) [\(elapsed)ms]", level: .Info).print()

                    if resp.statusCode > 399 {

                        dispatch_async(dispatch_get_main_queue(), {
                            handler?(resp, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
                        })

                    } else if let d = data {

                        let json = try! NSJSONSerialization.JSONObjectWithData(d, options: []) as! [String : AnyObject]
                        let token = Token(json)

                        switch req.authenticationMode {
                        case .App:
                            Router.appToken = token
                        case .User:
                            Router.userToken = token
                        }

                        dispatch_async(dispatch_get_main_queue(), {
                            handler?(resp, .Success(token, false))
                        })

                    }

                    self.isRefreshing = false

                    // Restart cached tasks
                    let cachedTasksCopy = self.cachedTasks
                    self.cachedTasks.removeAll()
                    let _ = cachedTasksCopy.map { (task) -> Void in
                        self.startRequest(request: task.request, numberOfRetries: task.numberOfRetries, completionHandler: task.handler)
                    }
                }
            }).resume()

        } else {
            LogMessage("No credentials found", level: .Error).print()
            handler?(nil, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
        }
    }

    // MARK: SSL Pinning

    func evaluateServerTrust(serverTrust: SecTrust, isValidForHost host: String) -> Bool {
        let policy = SecPolicyCreateSSL(true, host as CFString)
        SecTrustSetPolicies(serverTrust, [policy])

        SecTrustSetAnchorCertificates(serverTrust, certificatesInBundle(NSBundle(identifier: "com.mobgen.Halo")!))
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
                certificate = SecCertificateCreateWithData(nil, certificateData) {
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

    public func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
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
