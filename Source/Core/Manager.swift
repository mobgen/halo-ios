//
//  Manager.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

public enum HaloEnvironment {
    case Int
    case QA
    case Prod
}

/// Core manager of the Framework implemented as a Singleton
@objc(HaloManager)
public class Manager: NSObject {

    /// Shared instance of the manager (Singleton pattern)
    public static let sharedInstance = Halo.Manager()

    /// General content component
    public let generalContent = Halo.GeneralContent.sharedInstance

    /// Singleton instance of the networking component
    private let net = Halo.NetworkManager.instance

    public var environment: HaloEnvironment {
        set {
            switch newValue {
            case .Int:
                Router.baseURL = NSURL(string: "http://halo-int.mobgen.com:3000")
            case .QA:
                Router.baseURL = NSURL(string: "http://halo-qa.mobgen.com:3000")
            case .Prod:
                Router.baseURL = NSURL(string: "http://halo.mobgen.com:3000")
            }
        }
        get {
            return .Prod
        }

    }

    private override init() {}

    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {

    }

    /**
    Perform the initial tasks to properly set up the SDK

    - returns Bool describing whether the process has succeeded
    */
    public func launch() -> Bool {

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

        UIApplication.sharedApplication().registerForRemoteNotifications()

        /// Print default system tags
        print("----------")
        print("Platform name: iOS")
        print("OS version: \(NSProcessInfo.processInfo().operatingSystemVersionString)")
        if let appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") {
            print("App name: \(appName)")
        }

        if let appVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") {
            print("App version: \(appVersion)")
        }

        print("Device model: \(UIDevice.currentDevice().modelName)")
        print("----------")

        return true
    }

    /**
    Set up the desired push notifications to be received. To be called after the device has been
    registered
    */
    public func setupPushNotifications() {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }

    /**
    Get a list of the existing modules for the provided client credentials

    - parameter completionHandler:  Closure to be executed when the request has finished
    */
    public func getModules(completionHandler handler: (Alamofire.Result<[Halo.Module]>) -> Void) -> Void {
        net.getModules(completionHandler: handler)
    }

    // MARK: ObjC exposed methods

    /**
    Get a list of the existing modules for the provided client credentials

    - parameter success:  Closure to be executed when the request has succeeded
    - parameter failure:  Closure to be executed when the request has failed
    */
    @objc(getModulesWithSuccess:failure:)
    public func getModulesFromObjC(success: ((userData: [Halo.Module]) -> Void)?, failure: ((error: NSError) -> Void)?) -> Void {

        self.getModules { (result) -> Void in
            switch result {
            case .Success(let modules):
                success?(userData: modules)
            case .Failure(_, let error):
                failure?(error: error)
            }
        }
    }
}