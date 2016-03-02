//
//  HaloRequest.swift
//  HaloSDK
//
//  Created by Borja on 10/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public class Request: CustomDebugStringConvertible {

    private var url: NSURL?
    private var include = false
    private var method: Halo.Method = .GET
    private var parameterEncoding: Halo.ParameterEncoding = .URL
    private var headers: [String: String] = [:]
    internal var params: [String: AnyObject]? = [:]

    public var URLRequest: NSMutableURLRequest {
        let req = NSMutableURLRequest(URL: self.url!)
        
        req.HTTPMethod = self.method.rawValue
        
        if let token = Router.token {
            req.setValue("\(token.tokenType!) \(token.token!)", forHTTPHeaderField: "Authorization")
        }
        
        for (key, value) in self.headers {
            req.setValue(value, forHTTPHeaderField: key)
        }
        
        if self.include {
            self.params!["include"] = true
        }
        
        switch self.parameterEncoding {
        case .URL:
            if let url = NSURLComponents(URL: self.url!, resolvingAgainstBaseURL: true) {
                url.queryItems = self.params?.flatMap({ (key, value) -> NSURLQueryItem? in
                    return NSURLQueryItem(name: key, value: String(value).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()))
                })
                req.URL = url.URL
            }
        case .JSON:
            req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            if let params = self.params {
                req.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
            }
        case .FORM:
            req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            let queryString = self.params?.flatMap({ (key, value) -> String? in
                return "\(key)=\(String(value).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)"
            }).joinWithSeparator("&")

            req.HTTPBody = queryString?.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        return req
        
    }

    public var debugDescription: String {
        return self.URLRequest.curlRequest + "\n"
    }

    public init(path: String, relativeToURL: NSURL? = Router.baseURL) {
        self.url = NSURL(string: path, relativeToURL: relativeToURL)
    }

    init(router: Router) {
        self.url = NSURL(string: router.path, relativeToURL: Router.baseURL)
        self.method = router.method
        self.parameterEncoding = router.parameterEncoding
        self.headers = router.headers
        self.params = router.params
    }

    public func method(method: Halo.Method) -> Halo.Request {
        self.method = method
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
        self.params = params
        return self
    }

    public func includeAll() -> Halo.Request {
        self.include = true
        return self
    }

    public func responseData(completionHandler handler:((Halo.Result<NSData, NSError>) -> Void)? = nil) -> Halo.Request {
        
        Manager.network.startRequest(request: self) { (resp, result) in
            handler?(result)
        }
        
        return self
    }
    
    public func response(completionHandler handler: ((Halo.Result<AnyObject, NSError>) -> Void)? = nil) -> Halo.Request {
        
        self.responseData { (result) -> Void in
            switch result {
            case .Success(let data, _):
                if let successHandler = handler {
                    let json = try! NSJSONSerialization.JSONObjectWithData(data, options: [])
                    successHandler(.Success(json, false))
                }
            case .Failure(let error):
                handler?(.Failure(error))
            }
        }
        return self
    }
    
    
}