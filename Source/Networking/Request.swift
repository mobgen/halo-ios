//
//  HaloRequest.swift
//  HaloSDK
//
//  Created by Borja on 10/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

public class Request: URLRequestConvertible {

    private var url: NSURL?
    private var page: Int?
    private var limit: Int?
    private var include = false
    private var method: Halo.Method = .GET
    private var params: [String: AnyObject]? = [:]
    private var parameterEncoding: Halo.ParameterEncoding = .URL
    private var headers: [String: String] = [:]
    
    public var URLRequest: NSMutableURLRequest {

        var req = NSMutableURLRequest(URL: self.url!)
        req.HTTPMethod = self.method.toAlamofire().rawValue

        if let token = Router.token {
            req.setValue("\(token.tokenType!) \(token.token!)", forHTTPHeaderField: "Authorization")
        }
        
        if let alias = Router.userAlias {
            req.setValue(alias, forHTTPHeaderField: "X-AppUser-Alias")
        }
        
        for (key, value) in self.headers {
            req.setValue(value, forHTTPHeaderField: key)
        }

        if self.include {
            self.params!["include"] = true
        }

        if let page = self.page, limit = self.limit {
            self.params!["page"] = page
            self.params!["limit"] = limit
        }

        switch self.parameterEncoding {
        case .URL:
            req = Alamofire.ParameterEncoding.URL.encode(req, parameters: self.params).0
        case .JSON:
            req = Alamofire.ParameterEncoding.JSON.encode(req, parameters: self.params).0
        }

        return req
    }

    init(path: String, relativeToURL: NSURL? = Router.baseURL) {
        self.url = NSURL(string: path, relativeToURL: relativeToURL)
    }

    internal init(router: Router) {
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

    public func addHeaders(headers: [String: String]) -> Halo.Request {
        let _ = headers.map { (key, value) -> Void in
            let _ = self.addHeader(field: key, value: value)
        }
        return self
    }

    public func params(params: [String: AnyObject]) -> Halo.Request {
        self.params = params
        return self
    }

    public func includeAll() -> Halo.Request {
        self.include = true
        return self
    }

    public func paginate(page page: Int, limit: Int) -> Halo.Request {
        self.page = page
        self.limit = limit
        return self
    }

    
    public func response(completionHandler handler: ((Halo.Result<AnyObject, NSError>) -> Void)?) -> Void {
        
        NetworkManager.instance.startRequest(request: self) { (request, response, result) -> Void in
            handler?(result)
        }
        
    }

}