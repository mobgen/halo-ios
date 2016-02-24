//
//  Result.swift
//  HaloSDK
//
//  Created by Borja on 09/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

public enum Result<Value, Error : ErrorType> {

    case Success(Value, Bool)
    case Failure(Error)

}

@objc
public enum Method: Int {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT

    func toAlamofire() -> Alamofire.Method {
        switch self {
        case .OPTIONS: return .OPTIONS
        case .GET: return .GET
        case .HEAD: return .HEAD
        case .POST: return .POST
        case .PUT: return .PUT
        case .PATCH: return .PATCH
        case .DELETE: return .DELETE
        case .TRACE: return .TRACE
        case .CONNECT: return .CONNECT
        }
    }
}

