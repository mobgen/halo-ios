//
//  HaloError.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 16/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc
public enum HaloLogLevel: Int {
    case None = 0,
    Error = 1,
    Warning = 2,
    Info = 3

    public var description: String {
        switch self {
        case .Info: return "INFO"
        case .Warning: return "WARNING"
        case .Error: return "ERROR"
        default: return ""
        }
    }
}

@objc(HaloLogMessage)
public class LogMessage: NSObject {

    private var message: String = ""
    private var level: HaloLogLevel = .Error

    public override var debugDescription: String {
        return "<HALO/\(self.level.description)>: \(self.message)"
    }

    public init(_ message: String, level: HaloLogLevel) {
        super.init()
        self.message = message
        self.level = level
    }

    public init(_ message: String? = nil, error: NSError) {
        super.init()

        if let msg = message {
            self.message = "\(msg): \(error.localizedDescription)"
        } else {
            self.message = error.localizedDescription
        }

        self.level = .Error
    }

    public func print() -> Void {
        if Manager.core.logLevel.rawValue >= self.level.rawValue {
            NSLog(self.debugDescription)
        }
    }
}
