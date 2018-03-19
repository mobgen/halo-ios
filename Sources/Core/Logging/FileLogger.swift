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
    public var filePath: URL?
    let formatter = DateFormatter()
    
    override public init() {
        super.init()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"

        let filename = "\("Halo")-\(NSDate().timeIntervalSince1970).txt"
        filePath = dir?.appendingPathComponent(filename)

    }
    
    public func logMessage(_ message: String, level: LogLevel) {
        
        if let file = filePath {
            
            let date = formatter.string(from: Date())
            
            if let data = "[\(date)] \(message)\n".data(using: .utf8) {
                if FileManager.default.fileExists(atPath: file.path),
                    let fileHandle = FileHandle(forWritingAtPath: file.path) {
                    
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                } else {
                    try? data.write(to: file, options: .atomic)
                }
            }
        }
    }
    
}
