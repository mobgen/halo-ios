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
public class Manager : NSObject {
    
    /// Shared instance of the manager (Singleton pattern)
    public static let sharedInstance = Manager()
    
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
        
        if let cId = clientId {
            print("Using client ID: \(cId) and client secret: \(clientSecret!)")
        }
        
        return true
    }
    
    
    public func authenticate(clientId: String!, clientSecret: String!, completionHandler handler: (result: HaloResult<NSDictionary, NSError>) -> Void) -> Void {
        networking.haloAuthenticate(clientId, clientSecret: clientSecret, completionHandler: handler)
    }
    
    public func getModules(completionHandler handler: (result: HaloResult<[String], NSError>) -> Void) -> Void {
        networking.haloModules(completionHandler: handler)
    }
    
    // MARK: ObjC exposed methods
    
    @objc(authenticateWithClientId:clientSecret:completionHandler:)
    public func authenticateFromObjC(clientId: String!, clientSecret: String!, completionHandler handler: (userData: NSDictionary?, error: NSError?) -> Void) -> Void {
        networking.haloAuthenticate(clientId, clientSecret: clientSecret) { (result) -> Void in
            handler(userData: result.value, error: result.error);
        }
    }
    
}