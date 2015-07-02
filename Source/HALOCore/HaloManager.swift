//
//  Manager.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation


/// Core manager of the Framework implemented as a Singleton which has knowledge
/// about all the existing and active modules
@objc(HaloManager)
public class HaloManager {
    
    /// Shared instance of the manager (Singleton pattern)
    public static let sharedInstance = HaloManager()
    
    /// Client id to be used when authenticating against the HALO backend
    public var clientId:String?
    
    /// Client secret to be used when authenticating against the HALO backend
    public var clientSecret:String?
    
    /// User token to be used for API requests
    internal(set) public var token:String?
    
    /// Refresh token to be used when the existing one has expired
    internal(set) public var refreshToken:String?
    
    /// Collection of installed modules
    var modules:Dictionary<String, HaloModule> = Dictionary()
    
    /**
    Start the HALO core
    
    :returns: Bool describing whether the process has succeeded
    */
    public func launch() -> Bool {
        
        println("********************************")
        println("*** Launching HALO Framework ***")
        println("********************************")
        
        let bundle = NSBundle.mainBundle()
        if let path = bundle.pathForResource("HALO", ofType: "plist") {
            
            if let data = NSDictionary(contentsOfFile: path) {
                clientId = data["CLIENT_ID"] as? String
                clientSecret = data["CLIENT_SECRET"] as? String
                
                if let arr = data["MODULES"] as? Array<Dictionary<String,AnyObject>> {
                    for d in arr {
                        let cl = NSClassFromString(d["HALO_MODULE_CLASS"] as! String) as! HaloModule.Type
                        let instance = cl(config: d)
                        addModule(instance)
                    }
                }
            }
        }
        
        println("Using client ID: \(clientId!) and client secret: \(clientSecret!)")
        listModules()
        return false
    }
    
    /**
    Add a module to the list of active modules
    
    :param: module   New module to be added
    :returns: Boolean specifying whether the operation has succeeded or not
    */
    public func addModule(module: HaloModule) -> Bool {
        
        if let type = module.moduleType {
            modules[type.raw] = module
            module.manager = self
            return true;
        }
        return false;
    }
    
    /**
    Get a module by name
    
    :param: moduleName   Name of the module to be retrieved
    :returns: The requested module (if it exists)
    */
    public func getModule(type: HaloModuleType) -> HaloModule? {
        return modules[type.raw]
    }
    
    /**
    Prints a list of all the active modules. Intended to be used for debugging
    */
    public func listModules() {
        println("--- Listing active modules ---")

        for (k: String, mod:HaloModule) in modules {
            println(mod.moduleDescription())
        }
        println("------------------------------")
    }
    
}