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
    private let net = Halo.NetworkManager.instance

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
    public func getModules(success: ((userData: [Halo.HaloModule]) -> Void)?, failure: ((error: NSError) -> Void)?) -> Void {
        net.getModules { (result) -> Void in
            switch result {
            case .Success(let modules):
                success?(userData: modules)
            case .Failure(_, let error):
                failure?(error: error)
            }
        }
    }

}
