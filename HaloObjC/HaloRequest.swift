//
//  HaloRequest.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 11/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Halo

@objc
public enum HaloOfflinePolicy: Int {
    case none, loadAndStoreLocalData, returnLocalDataDontLoad
}

@objc
public enum HaloMethod: Int {
    case options, get, head, post, put, patch, delete, trace, connect
}

@objc
public enum HaloParameterEncoding: Int {
    case url, urlEncodedInURL, json
}

extension Request {
    
    
    
}

open class HaloRequest: NSObject {

    fileprivate var request: Halo.Request<Any>?

    public init(path: String, relativeToURL: URL?) {
        request = Halo.Request<Any>(path: path, relativeToURL: relativeToURL)
        super.init()
    }

    init(request haloRequest: Halo.Request<Any>) {
        request = haloRequest
        super.init()
    }

    @objc(offlinePolicy:)
    open func offlinePolicy(_ policy: HaloOfflinePolicy) -> HaloRequest {

        let newPolicy: Halo.OfflinePolicy

        switch policy {
        case .none: newPolicy = .none
        case .loadAndStoreLocalData: newPolicy = .loadAndStoreLocalData
        case .returnLocalDataDontLoad: newPolicy = .returnLocalDataDontLoad
        }

        request?.offlinePolicy(newPolicy)
        return self
    }

    @objc(method:)
    open func method(_ method: HaloMethod) -> HaloRequest {

        let newMethod: Halo.Method

        switch method {
        case .connect: newMethod = .CONNECT
        case .delete: newMethod = .DELETE
        case .get: newMethod = .GET
        case .head: newMethod = .HEAD
        case .options: newMethod = .OPTIONS
        case .patch: newMethod = .PATCH
        case .post: newMethod = .POST
        case .put: newMethod = .PUT
        case .trace: newMethod = .TRACE
        }

        request?.method(newMethod)
        return self
    }

    @objc(parameterEncoding:)
    open func parameterEncoding(_ encoding: HaloParameterEncoding) -> HaloRequest {

        let newEncoding: Halo.ParameterEncoding

        switch encoding {
        case .json: newEncoding = .json
        case .url: newEncoding = .url
        case .urlEncodedInURL: newEncoding = .urlEncodedInURL
        }

        request?.parameterEncoding(newEncoding)
        return self
    }

    open func addHeader(field: String, value: String) -> HaloRequest {
        request?.addHeader(field: field, value: value)
        return self
    }

    @objc(addHeaders:)
    open func addHeaders(_ headers: [String : String]) -> HaloRequest {
        request?.addHeaders(headers)
        return self
    }

    @objc(params:)
    open func params(_ params: [String : AnyObject]) -> HaloRequest {
        request?.params(params)
        return self
    }

    open func includeAll() -> HaloRequest {
        request?.includeAll()
        return self
    }

    open func paginate(page: Int, limit: Int) -> HaloRequest {
        request?.paginate(page: page, limit: limit)
        return self
    }

    open func skipPagination() -> HaloRequest {
        request?.skipPagination()
        return self
    }

    @objc(fields:)
    open func fields(_ fields: [String]) -> HaloRequest {
        request?.fields(fields)
        return self
    }

    open func tags(_ tags: [Halo.Tag]) -> HaloRequest {
        request?.tags(tags)
        return self
    }

    open func responseData(success: @escaping ((HTTPURLResponse?, Data, Bool) -> Void), failure: @escaping ((HTTPURLResponse?, NSError) -> Void)) -> HaloRequest {

        do {
            try request?.responseData { (response, result) -> Void in
                switch result {
                case .success(let data, let cached):
                    success(response, data, cached)
                case .failure(let error):
                    failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: error.description]))
                }
            }
        } catch _ {
            LogMessage(message: "Error performing request: \(self.debugDescription)", level: .error).print()
        }

        return self
    }

    open func response(success: @escaping ((HTTPURLResponse?, Any?, Bool) -> Void), failure: @escaping ((HTTPURLResponse?, NSError) -> Void)) -> HaloRequest {

        do {
            try request?.response { (response, result) -> Void in
                switch result {
                case .success(let data, let cached):
                    success(response, data, cached)
                case .failure(let error):
                    failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: error.description]))
                }
            }
        } catch _ {
            LogMessage(message: "Error performing request: \(self.debugDescription)", level: .error).print()
        }

        return self
    }
}
