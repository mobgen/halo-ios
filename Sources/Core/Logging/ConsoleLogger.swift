//
//  ConsoleLogger.swift
//  Halo
//
//  Created by Borja Santos-Díez on 25/01/17.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloConsoleLogger)
open class ConsoleLogger: NSObject, Logger {
    
    public func logMessage(_ message: String, level: LogLevel) {
        NSLog("<HALO/\(level.description)>: \(message)")
    }
    
}
