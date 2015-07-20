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
@objc
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
    Start the Halo SDK setup
    
    :returns: Bool describing whether the process has succeeded
    */
    public func launch() -> Bool {
        
        println("********************************")
        println("***** Welcome to Halo SDK ******")
        println("********************************")
        
        let bundle = NSBundle.mainBundle()
        if let path = bundle.pathForResource("HALO", ofType: "plist") {
            
            if let data = NSDictionary(contentsOfFile: path) {
                clientId = data["CLIENT_ID"] as? String
                clientSecret = data["CLIENT_SECRET"] as? String
            }
        }
        
        addModule(HaloNetworking());
        
        if let cId = clientId {
            println("Using client ID: \(cId) and client secret: \(clientSecret!)")
        }
        
        return true
    }
    
    /**
    Add a module to the list of active modules
    
    :param: module   New module to be added
    :returns: Boolean specifying whether the operation has succeeded or not
    */
    public func addModule(module: HaloModule) -> Bool {
        
        modules[toString(module.dynamicType)] = module
        module.manager = self
        return true
    }
    
    /**
    Get a module by name
    
    :param: moduleName   Name of the module to be retrieved
    :returns: The requested module (if it exists)
    */
    public func getModule(moduleClass: HaloModule.Type) -> HaloModule? {
        return modules[toString(moduleClass)]
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