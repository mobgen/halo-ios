//
//  Router.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

/// Custom implementation of the URLRequestConvertible protocol to handle the HTTP requests nicely
enum Router: URLRequestConvertible {

    /// Common base url of all the API endpoints
    static let baseURL = NSURL(string: "http://halo-qa.mobgen.com:3000")

    /// Token to be used for authentication purposes
    static var token:Token?

    /// Request authentication providing the required parameters
    case OAuth([String: AnyObject])

    /// Request the existing modules for a given client
    case Modules

    /// Get the existing instances of a given general content module
    case GeneralContentInstances([String: AnyObject])

    /// Decide the HTTP method based on the specific request
    var method: Alamofire.Method {
        switch self {
        case .OAuth(_):
            return .POST
        default:
            return .GET
        }
    }

    /// Decide the URL based on the specific request
    var path: String {
        switch self {
        case .OAuth(_):
            return "/api/oauth/token?_1"
        case .Modules:
            return "/api/authentication/module/list"
        case .GeneralContentInstances(_):
            return "api/generalcontent/instance/list"
        }
    }

    // MARK: URLRequestConvertible

    /// Get the right URL request with the right headers
    var URLRequest: NSMutableURLRequest {
        let url = NSURL(string: path, relativeToURL: Router.baseURL)
        let mutableURLRequest = NSMutableURLRequest(URL: url!)
        mutableURLRequest.HTTPMethod = method.rawValue

        if let token = Router.token {
            mutableURLRequest.setValue("\(token.tokenType!) \(token.token!)", forHTTPHeaderField: "Authorization")
        }

        switch self {
        case .OAuth(let params):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        case .GeneralContentInstances(let params):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        default:
            return mutableURLRequest
        }
    }
}
