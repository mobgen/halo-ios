//
//  Manager.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

/// Core manager of the Framework implemented as a Singleton
@objc(HaloManager)
public class Manager: NSObject {

    /// Shared instance of the manager (Singleton pattern)
    public static let sharedInstance = Manager()

    /// Singleton instance of the networking component
    private let net = Halo.Networking.sharedInstance

    private override init() {}

    /**
    Perform the initial tasks to properly set up the SDK

    - returns Bool describing whether the process has succeeded
    */
    public func launch() -> Bool {

        print("********************************")
        print("***** Welcome to Halo SDK ******")
        print("********************************")

        let bundle = NSBundle.mainBundle()
        if let path = bundle.pathForResource("Halo", ofType: "plist") {

            if let data = NSDictionary(contentsOfFile: path) {
                net.clientId = data[HaloCoreConstants.clientIdKey] as? String
                net.clientSecret = data[HaloCoreConstants.clientSecret] as? String
            }
        }

        if let cId = net.clientId {
            print("Using client ID: \(cId) and client secret: \(net.clientSecret!)")
        }

        return true
    }

    /**
    Get a list of the existing modules for the provided client credentials
    
    - parameter completionHandler:  Closure to handle the result of the request asynchronously
    */
    public func getModules(completionHandler handler: (result: Alamofire.Result<[Halo.HaloModule]>) -> Void) -> Void {
        net.getModules(completionHandler: handler)
    }

    // MARK: ObjC exposed methods

    /**
    Get a list of the existing modules (from ObjC code) for the provided client credentials

    - parameter completionHandler:  Closure to handle the result of the request asynchronously
    */
    @objc(getModulesWithCompletionHandler:)
    public func getModulesFromObjC(completionHandler handler: (userData: [HaloModule]?, error: NSError?) -> Void) -> Void {
        self.getModules { (result) -> Void in
            handler(userData: result.value, error: result.error)
        }
    }
}
