//
//  HaloRequest.swift
//  HaloSDK
//
//  Created by Borja on 10/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public enum AuthenticationMode: Int {
    case App, User
}

public protocol Requestable {
    var URLRequest: NSMutableURLRequest { get }
    var authenticationMode: Halo.AuthenticationMode { get }
    var offlinePolicy: Halo.OfflinePolicy { get }
    var numberOfRetries: Int { get }
}

public class Request<T>: Requestable, CustomDebugStringConvertible {

    private var url: NSURL?
    private var include = false
    private var method: Halo.Method = .GET
    private var parameterEncoding: Halo.ParameterEncoding = .URL
    private var headers: [String: String] = [:]
    private var params: [String: AnyObject] = [:]

    public private(set) var responseParser: ((AnyObject) -> T?)?
    public private(set) var authenticationMode: Halo.AuthenticationMode = .App
    public private(set) var offlinePolicy = Manager.core.defaultOfflinePolicy {
        didSet {
            switch offlinePolicy {
            case .None: self.dataProvider = DataProviderManager.online
            case .LoadAndStoreLocalData: self.dataProvider = DataProviderManager.onlineOffline
            case .ReturnLocalDataDontLoad: self.dataProvider = DataProviderManager.offline
            }
        }
    }
    public private(set) var numberOfRetries: Int?
    
    private(set) var dataProvider: DataProvider = Manager.core.dataProvider

    public var URLRequest: NSMutableURLRequest {
        let req = NSMutableURLRequest(URL: self.url!)

        req.HTTPMethod = self.method.rawValue

        var token: Token?

        switch self.authenticationMode {
        case .App:
            token = Router.appToken
        case .User:
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

        return request

    }

    public var debugDescription: String {
        return self.URLRequest.curlRequest + "\n"
    }

    public init(path: String, relativeToURL: NSURL? = Router.baseURL) {
        self.url = NSURL(string: path, relativeToURL: relativeToURL)
    }

    public init(router: Router) {
        self.url = NSURL(string: router.path, relativeToURL: Router.baseURL)
        self.method = router.method
        self.parameterEncoding = router.parameterEncoding
        self.headers = router.headers

        if let params = router.params {
            let _ = params.map({ self.params[$0.0] = $0.1 })
        }
    }

    public func responseParser(parser parser: (AnyObject) -> T?) -> Halo.Request<T> {
        self.responseParser = parser
        return self
    }

    public func offlinePolicy(policy policy: Halo.OfflinePolicy) -> Halo.Request<T> {
        self.offlinePolicy = policy
        return self
    }

    public func numberOfRetries(retries retries: Int) -> Halo.Request<T> {
        self.numberOfRetries = retries
        return self
    }
    
    public func method(method method: Halo.Method) -> Halo.Request<T> {
        self.method = method
        return self
    }

    public func authenticationMode(mode mode: Halo.AuthenticationMode) -> Halo.Request<T> {
        self.authenticationMode = mode
        return self
    }

    public func parameterEncoding(encoding encoding: Halo.ParameterEncoding) -> Halo.Request<T> {
        self.parameterEncoding = encoding
        return self
    }

    public func addHeader(field field: String, value: String) -> Halo.Request<T> {
        self.headers[field] = value
        return self
    }

    public func addHeaders(headers headers: [String : String]) -> Halo.Request<T> {
        headers.forEach { (key, value) -> Void in
            let _ = self.addHeader(field: key, value: value)
        }
        return self
    }

    public func params(params params: [String : AnyObject]) -> Halo.Request<T> {
        params.forEach { self.params[$0] = $1 }
        return self
    }

    public func includeAll() -> Halo.Request<T> {
        self.include = true
        return self
    }

    public func paginate(page page: Int, limit: Int) -> Halo.Request<T> {
        self.params["page"] = page
        self.params["limit"] = limit
        return self
    }


    public func skipPagination() -> Halo.Request<T> {
        self.params["skip"] = "true"
        return self
    }

    public func fields(fields fields: [String]) -> Halo.Request<T> {
        self.params["fields"] = fields
        return self
    }

    public func tags(tags tags: [Halo.Tag]) -> Halo.Request<T> {
        tags.forEach { tag in
            let json = try! NSJSONSerialization.dataWithJSONObject(tag.toDictionary(), options: [])
            self.params["filter[tags][]"] = String(data: json, encoding: NSUTF8StringEncoding)
        }
        return self
    }

    public func hash() -> Int {

        let bodyHash = URLRequest.HTTPBody?.hash ?? 0
        let urlHash = URLRequest.URL?.hash ?? 0

        return bodyHash + urlHash
    }

    public func responseData(completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<NSData>) -> Void)? = nil) throws -> Halo.Request<T> {

        switch self.offlinePolicy {
        case .None:
            Manager.network.startRequest(request: self) { (resp, result) in
                handler?(resp, result)
            }
        default:
            throw HaloError.NotImplementedOfflinePolicy
        }

        return self
    }

    public func response(completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<AnyObject>) -> Void)? = nil) throws -> Halo.Request<T> {

        try self.responseData { (response, result) -> Void in
            switch result {
            case .Success(let data, _):
                if let successHandler = handler {
                    let json = try! NSJSONSerialization.JSONObjectWithData(data, options: [])
                    successHandler(response, .Success(json, false))
                }
            case .Failure(let error):
                handler?(response, .Failure(error))
            }
        }

        return self
    }

    public func responseObject(completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<T?>) -> Void)? = nil) throws -> Halo.Request<T> {

        guard let parser = self.responseParser else {
            throw HaloError.NotImplementedResponseParser
        }

        try self.response { (response, result) in
            switch result {
            case .Success(let data, _):
                handler?(response, .Success(parser(data), false))
            case .Failure(let error):
                handler?(response, .Failure(error))
            }
        }

        return self
    }

}
