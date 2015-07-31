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
public class Manager: NSObject {

    /// Shared instance of the manager (Singleton pattern)
    public static let sharedInstance = Manager()

    /// Singleton instance of the networking component
    let networking = Networking.sharedInstance

    private override init() {}

    /**
    Perform the initial tasks to properly set up the SDK

    :returns: Bool describing whether the process has succeeded
    */
    public func launch() -> Bool {

        print("********************************")
        print("***** Welcome to Halo SDK ******")
        print("********************************")

        let bundle = NSBundle.mainBundle()
        if let path = bundle.pathForResource("Halo", ofType: "plist") {

            if let data = NSDictionary(contentsOfFile: path) {
                networking.clientId = data[HaloCoreConstants.clientIdKey] as? String
                networking.clientSecret = data[HaloCoreConstants.clientSecret] as? String
            }
        }

        if let cId = networking.clientId {
            print("Using client ID: \(cId) and client secret: \(networking.clientSecret!)")
        }

        return true
    }

    /**
    Get a list of the existing modules for the provided client credentials
    
    :param:     completionHandler   Callback to handle the result of the request asynchronously
    */
    public func getModules(completionHandler handler: (result: Result<[HaloModule], NSError>) -> Void) -> Void {
        networking.getModules(completionHandler: handler)
    }

    // MARK: ObjC exposed methods

    /**
    Get a list of the existing modules (from ObjC code) for the provided client credentials

    :param:     completionHandler   Callback to handle the result of the request asynchronously
    */
    @objc(getModulesWithCompletionHandler:)
    public func getModulesFromObjC(completionHandler handler: (userData: [HaloModule]?, error: NSError?) -> Void) -> Void {
        self.getModules { (result) -> Void in
            handler(userData: result.value, error: result.error)
        }
    }
}
