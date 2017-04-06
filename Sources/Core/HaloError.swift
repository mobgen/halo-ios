//
//  HaloError.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 17/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public enum HaloError: Error, Hashable {

    case notImplementedResponseParser
    case notImplementedOfflinePolicy
    case failedToRegisterForRemoteNotifications(String)
    case noCachedContent
    case noInternetConnection
    case parsingError(String)
    case encodingError(String)
    case noDataReceived
    case noResponseReceived
    case noValidCredentialsFound
    case errorResponse(Int)
    case loginError(String?)
    case unknownError(Error?)
    
    public var description: String {
        switch self {
        case .notImplementedResponseParser: return "No response parser has been implemented"
        case .notImplementedOfflinePolicy: return "No offline policy has been implemented"
        case .failedToRegisterForRemoteNotifications(let message): return "Failed to register for remote notifications (\(message))"
        case .noCachedContent: return "No cached content for the current request"
        case .noInternetConnection: return "There is no internet connection available. Please try again later"
        case .parsingError(let message): return "Error parsing response. \(message)"
        case .encodingError(let message): return "An error has occurred when encoding the request (\(message))"
        case .noDataReceived: return "No data received from server"
        case .noResponseReceived: return "No response received from server"
        case .noValidCredentialsFound: return "No valid credentials were found"
        case .errorResponse(let code): return "An error has occurred (code \(code))"
        case .loginError(let message): return "An error has occurred while trying to log in (\(message as String?))"
        case .unknownError(let error):
            if let e = error {
                return "An unknown error occurred (\(e.localizedDescription))"
            } else {
                return "An unknown error ocurred"
            }
        }
    }
    
    public var hashValue: Int {
        return self.description.hashValue
    }
    
    public static func ==(lhs: HaloError, rhs: HaloError) -> Bool {
        return lhs.description == rhs.description
    }

}
