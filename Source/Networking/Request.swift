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
    case App, User
}

public class Request: CustomDebugStringConvertible {

    public private(set) var url: NSURL?
    public private(set) var include = false
    public private(set) var method: Halo.Method = .GET
    public private(set) var parameterEncoding: Halo.ParameterEncoding = .URL
    public private(set) var headers: [String: String] = [:]
    public private(set) var offlinePolicy = Manager.core.defaultOfflinePolicy
    public private(set) var params: [String: AnyObject] = [:]
    public private(set) var authenticationMode: Halo.AuthenticationMode = .App
    
    var URLRequest: NSMutableURLRequest {
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
        
        let (request, _) = self.parameterEncoding.encode(req, parameters: self.params)
        
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
    
    public func offlinePolicy(policy: Halo.OfflinePolicy) -> Halo.Request {
        self.offlinePolicy = policy
        return self
    }
    
    public func method(method: Halo.Method) -> Halo.Request {
        self.method = method
        return self
    }

    public func authenticationMode(mode: Halo.AuthenticationMode) -> Halo.Request {
        self.authenticationMode = mode
        return self
    }
    
    public func parameterEncoding(encoding: Halo.ParameterEncoding) -> Halo.Request {
        self.parameterEncoding = encoding
        return self
    }

    public func addHeader(field field: String, value: String) -> Halo.Request {
        self.headers[field] = value
        return self
    }

    public func addHeaders(headers: [String : String]) -> Halo.Request {
        let _ = headers.map { (key, value) -> Void in
            let _ = self.addHeader(field: key, value: value)
        }
        return self
    }

    public func params(params: [String : AnyObject]) -> Halo.Request {
        let _ = params.map { self.params[$0] = $1 }
        return self
    }

    public func includeAll() -> Halo.Request {
        self.include = true
        return self
    }

    public func paginate(page page: Int, limit: Int) -> Halo.Request {
        self.params["page"] = page
        self.params["limit"] = limit
        return self
    }
    
    public func skipPagination() -> Halo.Request {
        self.params["skip"] = "true"
        return self
    }
    
    public func fields(fields: [String]) -> Halo.Request {
        self.params["fields"] = fields
        return self
    }
    
    public func tags(tags: [Halo.Tag]) -> Halo.Request {
        let _ = tags.map({ tag in
            let json = try! NSJSONSerialization.dataWithJSONObject(tag.toDictionary(), options: [])
            self.params["filter[tags][]"] = String(data: json, encoding: NSUTF8StringEncoding)
        })
        return self
    }
    
    public func hash() -> Int {
        
        let bodyHash = URLRequest.HTTPBody?.hash ?? 0
        let urlHash = URLRequest.URL?.hash ?? 0
        
        return bodyHash + urlHash
    }
    
    public func responseData(completionHandler handler:((NSHTTPURLResponse?, Halo.Result<NSData, NSError>) -> Void)? = nil) throws -> Halo.Request {
        
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
    
    public func response(completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<AnyObject, NSError>) -> Void)? = nil) throws -> Halo.Request {
        
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
    
    public func responseObject<T>(responseParser: (AnyObject) -> T?, completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<T?, NSError>) -> Void)? = nil) throws -> Halo.Request {
        
        try self.response { (response, result) in
            switch result {
            case .Success(let data, _):
                handler?(response, .Success(responseParser(data), false))
            case .Failure(let error):
                handler?(response, .Failure(error))
            }
        }
        
        return self
    }
    
}