//
//  NetworkDataProvider.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public class NetworkDataProvider: DataProvider {

    public var numberOfRetries: Int = 0

    public func responseData(request: Requestable, completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<NSData, NSError>) -> Void)? = nil) throws -> Void {

        switch request.offlinePolicy {
        case .None:
            Manager.network.startRequest(request: request) { (resp, result) in
                handler?(resp, result)
            }
        default:
            throw HaloError.NotImplementedOfflinePolicy
        }

    }

    public func response(request: Requestable, completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<AnyObject, NSError>) -> Void)? = nil) throws -> Void {

        try self.responseData(request) { (response, result) -> Void in
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
    }

    public func responseObject<T>(request: Halo.Request<T>,
                               completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<T?, NSError>) -> Void)? = nil) throws -> Void {

        guard let parser = request.responseParser else {
            throw HaloError.NotImplementedResponseParser
        }

        try self.response(request) { (response, result) in
            switch result {
            case .Success(let data, _):
                handler?(response, .Success(parser(data), false))
            case .Failure(let error):
                handler?(response, .Failure(error))
            }
        }

    }


}
