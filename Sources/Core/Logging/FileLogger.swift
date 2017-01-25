//
//  FileLogger.swift
//  Halo
//
//  Created by Borja Santos-Díez on 25/01/17.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloFileLogger)
open class FileLogger: NSObject, Logger {
    
    let dir: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    var filePath: URL?
    
    override public init() {
        super.init()
        let filename = "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName"))-\(NSDate().timeIntervalSince1970).txt"
        filePath = dir?.appendingPathComponent(filename)
    }
    
    public func logMessage(message: String, level: LogLevel) {
        
        if let path = filePath {
            try? message.data(using: .utf8)?.write(to: path, options: .atomic)
        }
        
    }
    
}
