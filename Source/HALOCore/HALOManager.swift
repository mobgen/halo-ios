//
//  Manager.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HALOManager)
public class HALOManager {
    
    public static let shared = HALOManager()
    
    public var apiKey:String?
    public var clientSecret:String?
    
    var modules:Dictionary<String, HALOModule> = Dictionary()
    
    public func launch() -> Bool {
        
        println("********************************")
        println("*** Launching HALO Framework ***")
        println("********************************")
        
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("HALO", ofType: "plist")
        
        if let data = NSDictionary(contentsOfFile: path!) {
            apiKey = data["API_KEY"] as? String
            clientSecret = data["CLIENT_SECRET"] as? String
            
            println("Using API key: \(apiKey!) and client secret: \(clientSecret!)")
            
            if let arr = data["MODULES"] as? Array<NSDictionary> {
                for d in arr {
                    let cl = NSClassFromString(d["HALO_MODULE_CLASS"] as! String) as! HALOModule.Type
                    let instance = cl(config: d)
                    addModule(instance)
                }
            }
            
            listModules()
            return true
            
        } else {
            println("Error reading \(path)")
            return false
        }
    }
    
    public func addModule(module: HALOModule) -> Bool {
        modules[module.moduleName] = module
        return true;
    }
    
    public func getModule(moduleName: String) -> HALOModule? {
        return modules[moduleName]
    }
    
    public func listModules() {
        println("--- Listing active modules ---")
        for (k: String, mod:HALOModule) in modules {
            println(mod.moduleDescription())
        }
        println("------------------------------")
    }
    
}