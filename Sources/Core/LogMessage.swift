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

@objc(HaloLogMessage)
open class LogMessage: NSObject {

    var message: String = ""
    var level: LogLevel = .error

    open override var debugDescription: String {
        return "<HALO/\(self.level.description)>: \(self.message)"
    }
    
    public init(message: String, level: LogLevel) {
        super.init()
        self.message = message
        self.level = level
    }

    public init(message: String? = nil, error: HaloError) {
        super.init()

        if let msg = message {
            self.message = "\(msg): \(error.description)"
        } else {
            self.message = error.description
        }

        self.level = .error
    }

    open func print() -> Void {
        if Manager.core.logLevel.rawValue >= self.level.rawValue {
            NSLog(self.debugDescription)
        }
    }
}
