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
    public static var baseURL = URL(string: "https://halo.mobgen.com")

    /// Token to be used for authentication purposes
    static var appToken: Token?
    static var userToken: Token?

    case oAuth(Credentials, [String: Any])
    case versionCheck
    case modules
    case generalContentInstances([String: Any])
    case generalContentInstance(String)
    case generalContentSearch
    case moduleSync
    case segmentationGetDevice(String)
    case segmentationCreateDevice([String: Any])
    case segmentationUpdateDevice(String, [String: Any])
    case customRequest(Halo.Method, String, [String: Any]?)

    /// Decide the HTTP method based on the specific request
    var method: Halo.Method {
        switch self {
        case .oAuth(_, _),
             .segmentationCreateDevice(_),
             .generalContentSearch,
             .moduleSync:
            return .POST
        case .segmentationUpdateDevice(_):
            return .PUT
        case .customRequest(let method, _, _):
            return method
        default:
            return .GET
        }
    }

    /// Decide the URL based on the specific request
    var path: String {
        switch self {
        case .oAuth(let cred, _):
            switch cred.type {
            case .app:
                return "api/oauth/token?_app"
            case .user:
                return "api/oauth/token?_user"
            }
        case .versionCheck:
            return "api/authentication/version"
        case .modules:
            return "api/generalcontent/module"
        case .generalContentInstances(_):
            return "api/generalcontent/instance"
        case .generalContentInstance(let id):
            return "api/generalcontent/instance/\(id)"
        case .moduleSync:
            return "api/generalcontent/instance/sync"
        case .generalContentSearch:
            return "api/generalcontent/instance/search"
        case .segmentationCreateDevice(_):
            return "api/segmentation/appuser"
        case .segmentationGetDevice(let id):
            return "api/segmentation/appuser/\(id)"
        case .segmentationUpdateDevice(let id, _):
            return "api/segmentation/appuser/\(id)"
        case .customRequest(_, let url, _):
            return "api/\(url)"
        }
    }

    var headers: [String: String] {
        var h: [String: String] = [:]

        switch self {
        case .oAuth(let cred, _):
            if cred.type == .user {
                let string = "\(cred.username):\(cred.password)"
                if let data = string.data(using: String.Encoding.utf8) {
                    let base64string = data.base64EncodedString(options: [])
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
        case .oAuth(_, _):
            return .url
        case .versionCheck,
             .segmentationCreateDevice(_),
             .segmentationUpdateDevice(_, _),
             .generalContentSearch,
             .moduleSync:
            return .json
        case .customRequest(let method, _, _):
            switch method {
            case .POST, .PUT:
                return .json
            default:
                return .url
            }
        default:
            return .url
        }
    }

    var params: [String: Any]? {

        switch self {
        case .oAuth(_, let params): return params
        case .versionCheck: return ["current": "true"]
        case .generalContentInstances(let params): return params
        case .segmentationCreateDevice(let params): return params
        case .segmentationUpdateDevice(_, let params):
            var newParams = params
            newParams["replaceTokens"] = true
            return newParams
        case .customRequest(_, _, let params): return params
        default: return nil
        }

    }

}
