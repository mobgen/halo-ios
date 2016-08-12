//
//  HaloRequest.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 11/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Halo

@objc public enum HaloOfflinePolicy: Int {
    case None, LoadAndStoreLocalData, ReturnLocalDataDontLoad
}

@objc public enum HaloMethod: Int {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

@objc public enum HaloParameterEncoding: Int {
    case URL, URLEncodedInURL, JSON
}

public class HaloRequest: NSObject {
    
    private var request: Halo.Request<Any>?
    
    public init(path: String, relativeToURL: NSURL?) {
        request = Halo.Request<Any>(path: path, relativeToURL: relativeToURL)
        super.init()
    }
    
    init(request haloRequest: Halo.Request<Any>) {
        request = haloRequest
        super.init()
    }
    
    public func offlinePolicy(policy: HaloOfflinePolicy) -> HaloRequest {
        
        let newPolicy: Halo.OfflinePolicy
        
        switch policy {
        case .None: newPolicy = .None
        case .LoadAndStoreLocalData: newPolicy = .LoadAndStoreLocalData
        case .ReturnLocalDataDontLoad: newPolicy = .ReturnLocalDataDontLoad
        }
        
        request?.offlinePolicy(newPolicy)
        return self
    }
    
    public func method(method: HaloMethod) -> HaloRequest {
        
        let newMethod: Halo.Method
        
        switch method {
        case .CONNECT: newMethod = .CONNECT
        case .DELETE: newMethod = .DELETE
        case .GET: newMethod = .GET
        case .HEAD: newMethod = .HEAD
        case .OPTIONS: newMethod = .OPTIONS
        case .PATCH: newMethod = .PATCH
        case .POST: newMethod = .POST
        case .PUT: newMethod = .PUT
        case .TRACE: newMethod = .TRACE
        }
        
        request?.method(newMethod)
        return self
    }
    
    public func parameterEncoding(encoding: HaloParameterEncoding) -> HaloRequest {
        
        let newEncoding: Halo.ParameterEncoding
        
        switch encoding {
        case .JSON: newEncoding = .JSON
        case .URL: newEncoding = .URL
        case .URLEncodedInURL: newEncoding = .URLEncodedInURL
        }
        
        request?.parameterEncoding(newEncoding)
        return self
    }
    
    public func addHeader(field field: String, value: String) -> HaloRequest {
        request?.addHeader(field: field, value: value)
        return self
    }
    
    public func addHeaders(headers: [String : String]) -> HaloRequest {
        request?.addHeaders(headers)
        return self
    }
    
    public func params(params: [String : AnyObject]) -> HaloRequest {
        request?.params(params)
        return self
    }
    
    public func includeAll() -> HaloRequest {
        request?.includeAll()
        return self
    }
    
    public func paginate(page page: Int, limit: Int) -> HaloRequest {
        request?.paginate(page: page, limit: limit)
        return self
    }
    
    public func skipPagination() -> HaloRequest {
        request?.skipPagination()
        return self
    }
    
    public func fields(fields: [String]) -> HaloRequest {
        request?.fields(fields)
        return self
    }
    
    public func tags(tags: [Halo.Tag]) -> HaloRequest {
        request?.tags(tags)
        return self
    }
    
    public func responseData(success success:((NSHTTPURLResponse?, NSData, Bool) -> Void)?, failure:((NSHTTPURLResponse?, NSError) -> Void)?) -> HaloRequest {
        
        do {
            try request?.responseData { (response, result) -> Void in
                switch result {
                case .Success(let data, let cached):
                    success?(response, data, cached)
                case .Failure(let error):
                    failure?(response, error)
                }
            }
        } catch _ {
            NSLog("Error performing request: \(self.debugDescription)")
        }
        
        return self
    }
    
    public func response(success success:((NSHTTPURLResponse?, AnyObject, Bool) -> Void)?, failure:((NSHTTPURLResponse?, NSError) -> Void)?) -> HaloRequest {
        
        do {
            try request?.response { (response, result) -> Void in
                switch result {
                case .Success(let data, let cached):
                    success?(response, data, cached)
                case .Failure(let error):
                    failure?(response, error)
                }
            }
        } catch _ {
            NSLog("Error performing request: \(self.debugDescription)")
        }
        
        return self
    }
}