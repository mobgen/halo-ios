//
//  Manager.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(Manager)
public class Manager {
    
    public static let sharedInstance = Manager()
    
    public var apiKey:String?
    public var clientSecret:String?
    public var token:String?
    public var refreshToken:String?
    
    var modules:Dictionary<String, Module> = Dictionary()
    
    public func launch() -> Bool {
        
        println("********************************")
        println("*** Launching HALO Framework ***")
        println("********************************")
        
        let bundle = NSBundle.mainBundle()
        if let path = bundle.pathForResource("HALO", ofType: "plist") {
            
            if let data = NSDictionary(contentsOfFile: path) {
                apiKey = data["API_KEY"] as? String
                clientSecret = data["CLIENT_SECRET"] as? String
                
                if let arr = data["MODULES"] as? Array<NSDictionary> {
                    for d in arr {
                        let cl = NSClassFromString(d["HALO_MODULE_CLASS"] as! String) as! Module.Type
                        let instance = cl(config: d)
                        addModule(instance)
                    }
                }
            }
        }
        
        println("Using API key: \(apiKey!) and client secret: \(clientSecret!)")
        listModules()
        return false
    }
    
    public func addModule(module: Module) -> Bool {
        modules[module.moduleName] = module
        return true;
    }
    
    public func getModule(moduleName: String) -> Module? {
        return modules[moduleName]
    }
    
    public func listModules() {
        println("--- Listing active modules ---")
        for (k: String, mod:HALOCore.Module) in modules {
            println(mod.moduleDescription())
        }
        println("------------------------------")
    }
    
}