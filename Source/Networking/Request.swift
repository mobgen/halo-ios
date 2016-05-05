//
//  HaloRequest.swift
//  HaloSDK
//
//  Created by Borja on 10/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

public class Request: CustomDebugStringConvertible {

    private var url: NSURL?
    private var include = false
    private var method: Halo.Method = .GET
    private var parameterEncoding: Halo.ParameterEncoding = .URL
    private var headers: [String: String] = [:]
    private var offlineMode = Manager.core.defaultOfflinePolicy
    private var params: [String: AnyObject] = [:]

    var URLRequest: NSMutableURLRequest {
        let req = NSMutableURLRequest(URL: self.url!)
        
        req.HTTPMethod = self.method.rawValue
        
        if let token = Router.token {
            req.setValue("\(token.tokenType!) \(token.token!)", forHTTPHeaderField: "Authorization")
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

    init(router: Router) {
        self.url = NSURL(string: router.path, relativeToURL: Router.baseURL)
        self.method = router.method
        self.parameterEncoding = router.parameterEncoding
        self.headers = router.headers
        
        if let params = router.params {
            let _ = params.map({ self.params[$0.0] = $0.1 })
        }
    }

    public func offlinePolicy(policy: Halo.OfflinePolicy) -> Halo.Request {
        self.offlineMode = policy
        return self
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
    
    func hash() -> Int {
        
        let bodyHash = URLRequest.HTTPBody?.hash ?? 0
        let urlHash = URLRequest.URL?.hash ?? 0
        
        return bodyHash + urlHash
    }
    
    public func responseData(completionHandler handler:((Halo.Result<NSData, NSError>) -> Void)? = nil) -> Halo.Request {
        
        switch self.offlineMode {
        case .None:
            Manager.network.startRequest(request: self) { (resp, result) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    handler?(result)
                })
            }
        case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
            Manager.persistence.startRequest(request: self, useNetwork: (self.offlineMode == .LoadAndStoreLocalData), completionHandler: handler)
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