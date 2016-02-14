//
//  HaloRequest.swift
//  HaloSDK
//
//  Created by Borja on 10/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

public class Request<T>: URLRequestConvertible {

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

        for (key, value) in self.headers {
            req.setValue(value, forHTTPHeaderField: key)
        }

        if self.include {
            self.params!["include"] = true
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

    public func method(method: Halo.Method) -> Halo.Request<T> {
        self.method = method
        return self
    }

    public func parameterEncoding(encoding: Halo.ParameterEncoding) -> Halo.Request<T> {
        self.parameterEncoding = encoding
        return self
    }

    public func addHeader(field field: String, value: String) -> Halo.Request<T> {
        self.headers[field] = value
        return self
    }

    public func addHeaders(headers: [String: String]) -> Halo.Request<T> {
        let _ = headers.map { (key, value) -> Void in
            let _ = self.addHeader(field: key, value: value)
        }
        return self
    }

    public func params(params: [String: AnyObject]) -> Halo.Request<T> {
        self.params = params
        return self
    }

    public func includeAll() -> Halo.Request<T> {
        self.include = true
        return self
    }

    public func paginate(page: Int, limit: Int) -> Halo.Request<T> {
        self.page = page
        self.limit = limit
        return self
    }

    public func response(completionHandler handler: (NSURLRequest?, NSHTTPURLResponse?, Halo.Result<T, NSError>) -> Void) -> Void {
        NetworkManager.instance.startRequest(request: self, completionHandler: handler)
    }

}