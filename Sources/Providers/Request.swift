//
//  HaloRequest.swift
//  HaloSDK
//
//  Created by Borja on 10/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloAuthenticationMode)
public enum AuthenticationMode: Int {
    case app, appPlus, user
}

public protocol Requestable {
    var urlRequest: URLRequest { get }
    var authenticationMode: Halo.AuthenticationMode { get }
    var offlinePolicy: Halo.OfflinePolicy { get }
    var numberOfRetries: Int? { get }
    var bypassReadiness: Bool { get }
    var checkUnauthorised: Bool { get }
}

open class Request<T>: Requestable, CustomDebugStringConvertible {

    fileprivate var url: URL?
    fileprivate var include = false
    fileprivate var method: Halo.Method = .GET
    fileprivate var parameterEncoding: Halo.ParameterEncoding = .url
    fileprivate var headers: [String: String] = [:]
    fileprivate var params: [String: Any] = [:]
    public internal(set) var bypassReadiness: Bool = false
    public internal(set) var checkUnauthorised: Bool = true

    open fileprivate(set) var responseParser: ((Any?) -> T?)?
    open fileprivate(set) var authenticationMode: Halo.AuthenticationMode = Manager.core.defaultAuthenticationMode
    open fileprivate(set) var offlinePolicy = Manager.core.defaultOfflinePolicy {
        didSet {
            switch offlinePolicy {
            case .none: self.dataProvider = DataProviderManager.online
            case .loadAndStoreLocalData: self.dataProvider = DataProviderManager.onlineOffline
            case .returnLocalDataDontLoad: self.dataProvider = DataProviderManager.offline
            }
        }
    }
    open fileprivate(set) var numberOfRetries: Int?

    fileprivate(set) var dataProvider: DataProvider = Manager.core.dataProvider

    open var urlRequest: URLRequest {
        var req = URLRequest(url: self.url!)

        req.httpMethod = self.method.rawValue

        var token: Token?

        switch self.authenticationMode {
        case .app:
            token = Router.appToken
        case .appPlus:
            token = Router.appPlusToken
        case .user:
            token = Router.userToken
        }

        if let tok = token {
            req.setValue("\(tok.tokenType!) \(tok.token!)", forHTTPHeaderField: "Authorization")
        }

        for (key, value) in self.headers {
            req.setValue(value, forHTTPHeaderField: key)
        }

        if self.include {
            self.params["include"] = true
        }

        let (request, _) = self.parameterEncoding.encode(request: req, parameters: self.params)

        return request as URLRequest

    }

    open var debugDescription: String {
        return self.urlRequest.curlRequest + "\n"
    }

    public init(path: String, relativeToURL: URL? = Router.baseURL) {
        self.url = URL(string: path, relativeTo: relativeToURL)
    }

    public init(router: Router) {
        self.url = URL(string: router.path, relativeTo: Router.baseURL as URL?)
        self.method = router.method
        self.parameterEncoding = router.parameterEncoding
        self.headers = router.headers

        if let params = router.params {
            let _ = params.map({ self.params[$0.0] = $0.1 })
        }
    }

    convenience init(router: Router, bypassReadiness: Bool = false, checkUnauthorised: Bool = true) {
        self.init(router: router)
        self.bypassReadiness = bypassReadiness
        self.checkUnauthorised = checkUnauthorised
    }

    @discardableResult
    open func responseParser(_ parser: @escaping (Any?) -> T?) -> Halo.Request<T> {
        self.responseParser = parser
        return self
    }

    @discardableResult
    open func offlinePolicy(_ policy: Halo.OfflinePolicy) -> Halo.Request<T> {
        self.offlinePolicy = policy
        return self
    }

    @discardableResult
    open func numberOfRetries(_ retries: Int) -> Halo.Request<T> {
        self.numberOfRetries = retries
        return self
    }

    @discardableResult
    open func method(_ method: Halo.Method) -> Halo.Request<T> {
        self.method = method
        return self
    }

    @discardableResult
    open func authenticationMode(_ mode: Halo.AuthenticationMode) -> Halo.Request<T> {
        self.authenticationMode = mode
        return self
    }

    @discardableResult
    open func parameterEncoding(_ encoding: Halo.ParameterEncoding) -> Halo.Request<T> {
        self.parameterEncoding = encoding
        return self
    }

    @discardableResult
    open func addHeader(field: String, value: String) -> Halo.Request<T> {
        self.headers[field] = value
        return self
    }

    @discardableResult
    open func addHeaders(_ headers: [String : String]) -> Halo.Request<T> {
        headers.forEach { (key, value) -> Void in
            let _ = self.addHeader(field: key, value: value)
        }
        return self
    }

    @discardableResult
    open func params(_ params: [String : Any]) -> Halo.Request<T> {
        params.forEach { self.params[$0] = $1 }
        return self
    }

    @discardableResult
    open func includeAll() -> Halo.Request<T> {
        self.include = true
        return self
    }

    @discardableResult
    open func paginate(page: Int, limit: Int) -> Halo.Request<T> {
        self.params["page"] = page
        self.params["limit"] = limit
        return self
    }

    @discardableResult
    open func skipPagination() -> Halo.Request<T> {
        self.params["skip"] = "true"
        return self
    }

    @discardableResult
    open func fields(_ fields: [String]) -> Halo.Request<T> {
        self.params["fields"] = fields
        return self
    }

    @discardableResult
    open func tags(_ tags: [Halo.Tag]) -> Halo.Request<T> {
        tags.forEach { tag in
            let json = try! JSONSerialization.data(withJSONObject: tag.toDictionary(), options: [])
            self.params["filter[tags][]"] = String(data: json, encoding: String.Encoding.utf8)
        }
        return self
    }

    open func hash() -> Int {

        let bodyHash = (urlRequest.httpBody as NSData?)?.hash ?? 0
        let urlHash = (urlRequest.url as NSURL?)?.hash ?? 0

        return bodyHash + urlHash
    }

    @discardableResult
    open func responseData(_ handler: ((HTTPURLResponse?, Halo.Result<Data>) -> Void)? = nil) throws -> Halo.Request<T> {

        switch self.offlinePolicy {
        case .none:
            Manager.network.startRequest(request: self) { (resp, result) in
                handler?(resp, result)
            }
        default:
            throw HaloError.notImplementedOfflinePolicy
        }

        return self
    }

    @discardableResult
    open func response(_ handler: ((HTTPURLResponse?, Halo.Result<Any?>) -> Void)? = nil) throws -> Halo.Request<T> {

        try self.responseData { (response, result) -> Void in
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                switch result {
                case .success(let data, _):
                    if let successHandler = handler {
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        Manager.core.logMessage("Response body: \(json.debugDescription)", level: .info)
                        DispatchQueue.main.async {
                            successHandler(response, .success(json, false))
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        handler?(response, .failure(error))
                    }
                }
            }
        }

        return self
    }

    @discardableResult
    open func responseObject(_ handler: ((HTTPURLResponse?, Halo.Result<T?>) -> Void)? = nil) throws -> Halo.Request<T> {

        guard let parser = self.responseParser else {
            throw HaloError.notImplementedResponseParser
        }

        try self.response { (response, result) in
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                switch result {
                case .success(let data, _):
                    let parsedData = parser(data)
                    DispatchQueue.main.async {
                        handler?(response, .success(parsedData, false))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        handler?(response, .failure(error))
                    }
                }
            }
        }
        
        return self
    }
    
}
