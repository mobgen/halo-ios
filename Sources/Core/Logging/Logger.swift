//
//  HaloError.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 16/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc
public enum LogLevel: Int {
    case none = 0,
    error = 1,
    warning = 2,
    info = 3

    public var description: String {
        switch self {
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        default: return "UNKNOWN"
        }
    }
}

@objc(HaloLogger)
public protocol Logger {
    
    @objc(logMessage:withLevel:)
    func logMessage(_ message: String, level: LogLevel)
    
}
