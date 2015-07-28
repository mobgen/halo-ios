//
//  Manager.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Result

/// Core manager of the Framework implemented as a Singleton which has knowledge
/// about all the existing and active modules

@objc(HaloManager)
public class Manager : NSObject {
    
    /// Shared instance of the manager (Singleton pattern)
    public static let sharedInstance = Manager()
    
    /// Client id to be used when authenticating against the HALO backend
    public var clientId:String? {
        set {
            networking.clientId = newValue
        }
        get {
            return networking.clientId
        }
    }
    
    /// Client secret to be used when authenticating against the HALO backend
    public var clientSecret:String? {
        set {
            networking.clientSecret = newValue
        }
        get {
            return networking.clientSecret
        }
    }
    
    /// User token to be used for API requests
    public var token:HaloToken? {
        get {
            return networking.token
        }
    }
    
    let networking = Networking()
    
    /**
    Start the Halo SDK setup
    
    :returns: Bool describing whether the process has succeeded
    */
    public func launch() -> Bool {
        
        print("********************************")
        print("***** Welcome to Halo SDK ******")
        print("********************************")
        
        let bundle = NSBundle.mainBundle()
        if let path = bundle.pathForResource("Halo", ofType: "plist") {
            
            if let data = NSDictionary(contentsOfFile: path) {
                self.clientId = data[HaloCoreConstants.clientIdKey] as? String
                self.clientSecret = data[HaloCoreConstants.clientSecret] as? String
            }
        }
        
        if let cId = clientId {
            print("Using client ID: \(cId) and client secret: \(clientSecret!)")
        }
        
        return true
    }
    
    
    public func authenticate(clientId: String!, clientSecret: String!, completionHandler handler: (result: Result<HaloToken, NSError>) -> Void) -> Void {
        networking.authenticate(clientId, clientSecret: clientSecret, completionHandler: handler)
    }
    
    public func getModules(completionHandler handler: (result: Result<[HaloModule], NSError>) -> Void) -> Void {
        networking.getModules(completionHandler: handler)
    }
    
    // MARK: ObjC exposed methods
    
    @objc(authenticateWithClientId:clientSecret:completionHandler:)
    public func authenticateFromObjC(clientId: String!, clientSecret: String!, completionHandler handler: (userData: HaloToken?, error: NSError?) -> Void) -> Void {
        self.authenticate(clientId, clientSecret: clientSecret) { (result) -> Void in
            handler(userData: result.value, error: result.error)
        }
    }
    
}