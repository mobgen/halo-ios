//
//  Router.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

public enum ParameterEncoding: Int {
    case JSON, URL
}

/// Custom implementation of the URLRequestConvertible protocol to handle authentication nicely
enum Router {

    /// Common base url of all the API endpoints
    static var baseURL = NSURL(string: "https://halo.mobgen.com")

    /// Token to be used for authentication purposes
    static var token:Token?
    
    static var userAlias: String?

    case OAuth(Credentials, [String: AnyObject])
    case Modules
    case GeneralContentInstances([String: AnyObject])
    case GeneralContentInstance(String, [String: AnyObject])
    case SegmentationGetUser(String)
    case SegmentationCreateUser([String: AnyObject])
    case SegmentationUpdateUser(String, [String: AnyObject])
    case CustomRequest(Halo.Method, String, [String: AnyObject]?)

    /// Decide the HTTP method based on the specific request
    var method: Halo.Method {
        switch self {
        case .OAuth(_, _),
             .SegmentationCreateUser(_):
            return .POST
        case .SegmentationUpdateUser(_):
            return .PUT
        case .CustomRequest(let method, _, _):
            return method
        default:
            return .GET
        }
    }

    /// Decide the URL based on the specific request
    var path: String {
        switch self {
        case .OAuth(let cred, _):
            switch cred.type {
            case .App:
                return "/api/oauth/token?_1"
            case .User:
                return "/api/oauth/token?_2"
            }
        case .Modules:
            return "/api/authentication/module/"
        case .GeneralContentInstances(_):
            return "api/authentication/instance/"
        case .GeneralContentInstance(let id, _):
            return "api/generalcontent/instance/\(id)"
        case .SegmentationCreateUser(_):
            return "api/segmentation/appuser/"
        case .SegmentationGetUser(let id):
            return "api/segmentation/appuser/\(id)"
        case .SegmentationUpdateUser(let id, _):
            return "api/segmentation/appuser/\(id)?replaceTokens=true"
        case .CustomRequest(_, let url, _):
            return "api/\(url)"
        }
    }

    var headers: [String: String] {
        var h: [String: String] = [:]

        if let token = Router.token {
            h["Authorization"] = "\(token.tokenType!) \(token.token!)"
        }

        if let alias = Router.userAlias {
            h["X-AppUser-Alias"] = alias
        }

        switch self {
        case .OAuth(let cred, _):
            if cred.type == .User {
                let string = "\(cred.username):\(cred.password)"
                if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
                    let base64string = data.base64EncodedStringWithOptions([])
                    h["Authorization"] = "Basic \(base64string)"
                }
            }
        default:
            break
        }

        return h
    }

    var parameterEncoding: Halo.ParameterEncoding {
        switch self {
        case .SegmentationCreateUser(_), .SegmentationUpdateUser(_, _):
            return .JSON
        case .CustomRequest(let method, _, _):
            switch method {
            case .POST: return .JSON
            default: return .URL
            }
        default:
            return .URL
        }
    }

    var params: [String: AnyObject]? {

        switch self {
        case .OAuth(_, let params): return params
        case .GeneralContentInstances(let params): return params
        case .GeneralContentInstance(_, let params): return params
        case .SegmentationCreateUser(let params): return params
        case .SegmentationUpdateUser(_, let params): return params
        case .CustomRequest(_, _, let params): return params
        default: return nil
        }

    }

}
