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

    let networking = Networking.sharedInstance
    let generalContent = GeneralContent.sharedInstance

    private override init() {}

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
                networking.clientId = data[HaloCoreConstants.clientIdKey] as? String
                networking.clientSecret = data[HaloCoreConstants.clientSecret] as? String
            }
        }

        if let cId = networking.clientId {
            print("Using client ID: \(cId) and client secret: \(networking.clientSecret!)")
        }

        return true
    }


    public func authenticate(completionHandler handler: (result: Result<HaloToken, NSError>) -> Void) -> Void {
        networking.authenticate(completionHandler: handler)
    }

    public func getModules(completionHandler handler: (result: Result<[HaloModule], NSError>) -> Void) -> Void {
        networking.getModules(completionHandler: handler)
    }

    // MARK: ObjC exposed methods

    @objc(authenticateWithClientId:clientSecret:completionHandler:)
    public func authenticateFromObjC(clientId: String!, clientSecret: String!, completionHandler handler: (userData: HaloToken?, error: NSError?) -> Void) -> Void {
        self.authenticate() { (result) -> Void in
            handler(userData: result.value, error: result.error)
        }
    }
}
