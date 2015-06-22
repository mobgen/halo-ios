//
//  Manager.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc
public class HALOManager {
    
    static let shared = HALOManager()
    
    public var apiKey:String?
    public var clientSecret:String?
    
    var modules:Dictionary<NSString, HALOModule> = Dictionary()

    init() {
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("HALO", ofType: "plist")
        
        if let data = NSDictionary(contentsOfFile: path!) {
            println(data.description)
        }

    }
    
    public static func sharedManager() -> HALOManager {
        return HALOManager.shared
    }
    
    public func listModules() {
        for (k, mod:HALOModule) in modules {
            println(mod.moduleDescription())
        }
    }
    
}