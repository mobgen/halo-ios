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
public class Halo : NSObject {
    
    /// Shared instance of the manager (Singleton pattern)
    public static let sharedInstance = Halo()
    
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
    
    let networking:HaloNetworking = HaloNetworking()
    
    /**
    Start the Halo SDK setup
    
    :returns: Bool describing whether the process has succeeded
    */
    public func launch() -> Bool {
        
        print("********************************")
        print("***** Welcome to Halo SDK ******")
        print("********************************")
        
        let bundle = NSBundle.mainBundle()
        if let path = bundle.pathForResource("HALO", ofType: "plist") {
            
            if let data = NSDictionary(contentsOfFile: path) {
                clientId = data["CLIENT_ID"] as? String
                clientSecret = data["CLIENT_SECRET"] as? String
            }
        }
        
        addModule(HaloNetworking());
        
        if let cId = clientId {
            print("Using client ID: \(cId) and client secret: \(clientSecret!)")
        }
        
        return true
    }
    
    public func haloAuthenticate(clientId: String!, clientSecret: String!, completionHandler handler: (result: HaloResult<NSDictionary, NSError>) -> Void) -> Void {
        networking.haloAuthenticate(clientId, clientSecret: clientSecret, completionHandler: handler)
    }
    
    public func haloModules(completionHandler handler: (result: HaloResult<[String], NSError>) -> Void) -> Void {
        networking.haloModules(completionHandler: handler)
    }
    
    /**
    Add a module to the list of active modules
    
    :param: module   New module to be added
    :returns: Boolean specifying whether the operation has succeeded or not
    */
    func addModule(module: HaloModule) -> Bool {
        
        modules[String(module.dynamicType)] = module
        module.manager = self
        return true
    }
    
    /**
    Get a module by name
    
    :param: moduleName   Name of the module to be retrieved
    :returns: The requested module (if it exists)
    */
    func getModule(moduleClass: HaloModule.Type) -> HaloModule? {
        return modules[String(moduleClass)]
    }
    
    /**
    Prints a list of all the active modules. Intended to be used for debugging
    */
    func listModules() {
        print("--- Listing active modules ---")
        
        for (_, mod) in modules {
            print(mod.moduleDescription())
        }
        print("------------------------------")
    }
    
}