//
//  Router.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

/// Custom implementation of the URLRequestConvertible protocol to handle authentication nicely

import Foundation

public enum Router {

    /// Common base url of all the API endpoints
    public static var baseURL = NSURL(string: "https://halo.mobgen.com")

    /// Token to be used for authentication purposes
    static var appToken: Token?
    static var userToken: Token?

    case OAuth(Credentials, [String: AnyObject])
    case Modules
    case GeneralContentInstances([String: AnyObject])
    case GeneralContentInstance(String)
    case GeneralContentSearch
    case ModuleSync
    case SegmentationGetUser(String)
    case SegmentationCreateUser([String: AnyObject])
    case SegmentationUpdateUser(String, [String: AnyObject])
    case CustomRequest(Halo.Method, String, [String: AnyObject]?)

    /// Decide the HTTP method based on the specific request
    var method: Halo.Method {
        switch self {
        case .OAuth(_, _),
             .SegmentationCreateUser(_),
             .GeneralContentSearch,
             .ModuleSync:
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
                return "api/oauth/token?_app"
            case .User:
                return "api/oauth/token?_user"
            }
        case .Modules:
            return "api/authentication/module"
        case .GeneralContentInstances(_):
            return "api/authentication/instance"
        case .GeneralContentInstance(let id):
            return "api/generalcontent/instance/\(id)"
        case .ModuleSync:
            return "api/generalcontent/instance/sync"
        case .GeneralContentSearch:
            return "api/generalcontent/instance/search"
        case .SegmentationCreateUser(_):
            return "api/segmentation/appuser"
        case .SegmentationGetUser(let id):
            return "api/segmentation/appuser/\(id)"
        case .SegmentationUpdateUser(let id, _):
            return "api/segmentation/appuser/\(id)"
        case .CustomRequest(_, let url, _):
            return "api/\(url)"
        }
    }

    var headers: [String: String] {
        var h: [String: String] = [:]

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
        case .OAuth(_, _):
            return .URL
        case .SegmentationCreateUser(_),
             .SegmentationUpdateUser(_, _),
             .GeneralContentSearch,
             .ModuleSync:
            return .JSON
        case .CustomRequest(let method, _, _):
            switch method {
            case .POST, .PUT:
                return .JSON
            default:
                return .URL
            }
        default:
            return .URL
        }
    }

    var params: [String: AnyObject]? {

        switch self {
        case .OAuth(_, let params): return params
        case .GeneralContentInstances(let params): return params
        case .SegmentationCreateUser(let params): return params
        case .SegmentationUpdateUser(_, let params):
            var newParams = params
            newParams["replaceTokens"] = true
            return newParams
        case .CustomRequest(_, _, let params): return params
        default: return nil
        }

    }

}
