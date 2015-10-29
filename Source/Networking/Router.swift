//
//  Router.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

/// Custom implementation of the URLRequestConvertible protocol to handle authentication nicely
enum Router: URLRequestConvertible {

    /// Common base url of all the API endpoints
    static var baseURL = NSURL(string: "https://halo.mobgen.com")

    /// Token to be used for authentication purposes
    static var token:Token?
    
    static var userAlias: String?

    case OAuth([String: AnyObject])
    case Modules
    case GeneralContentInstances([String: AnyObject])
    case GeneralContentInstance(String)
    case SegmentationGetUser(String)
    case SegmentationCreateUser([String: AnyObject])
    case SegmentationUpdateUser(String, [String: AnyObject])
    case CustomRequest(Alamofire.Method, String, [String: AnyObject]?)

    /// Decide the HTTP method based on the specific request
    var method: Alamofire.Method {
        switch self {
        case .OAuth(_),
             .SegmentationCreateUser(_):
            return .POST
        case .SegmentationUpdateUser(_):
            return .PUT
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
            return "/api/authentication/module/"
        case .GeneralContentInstances(_):
            return "api/authentication/instance/"
        case .GeneralContentInstance(let id):
            return "api/generalcontent/instance/\(id)"
        case .SegmentationCreateUser(_):
            return "api/segmentation/appuser/"
        case .SegmentationGetUser(let id):
            return "api/segmentation/appuser/\(id)"
        case .SegmentationUpdateUser(let id, _):
            return "api/segmentation/appuser/\(id)"
        case .CustomRequest(_, let url, _):
            return "api/\(url)"
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

        if let alias = Router.userAlias {
            mutableURLRequest.setValue(alias, forHTTPHeaderField: "X-AppUser-Alias")
        }
        
        /**
        *  My god.. really awful. Think of a better way of doing this!
        */
        switch self {
        case .OAuth(let params):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        case .GeneralContentInstances(let params):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        case .SegmentationCreateUser(let params):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params).0
        case .SegmentationUpdateUser(_, let params):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params).0
        case .CustomRequest(let method, _, let params):
            switch method {
            case .POST:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params).0
            default:
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
            }
        default:
            return mutableURLRequest
        }
    }
}
