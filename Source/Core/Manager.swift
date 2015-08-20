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
import CoreBluetooth

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

    /// Bluetooth manager to decide whether the device supports BLE
    private let bluetoothManager:CBCentralManager = CBCentralManager(delegate: nil, queue: nil)

    /// Current environment (QA, Integration or Prod)
    public var environment: HaloEnvironment {
        didSet {
            switch environment {
            case .Int:
                Router.baseURL = NSURL(string: "http://halo-int.mobgen.com:3000")
            case .QA:
                Router.baseURL = NSURL(string: "http://halo-qa.mobgen.com:3000")
            case .Prod:
                Router.baseURL = NSURL(string: "http://halo.mobgen.com:3000")
            }
        }
    }

    private override init() {
        self.environment = .Prod
    }

    /**
    Perform the initial tasks to properly set up the SDK

    - returns Bool describing whether the process has succeeded
    */
    public func launch() -> Bool {

        let bundle = NSBundle.mainBundle()
        if let path = bundle.pathForResource("Halo", ofType: "plist") {

            if let data = NSDictionary(contentsOfFile: path) {
                net.clientId = data[CoreConstants.clientIdKey] as? String
                net.clientSecret = data[CoreConstants.clientSecret] as? String
            }
        }

        if let cId = net.clientId {
            print("Using client ID: \(cId) and client secret: \(net.clientSecret!)")
        }

        UIApplication.sharedApplication().registerForRemoteNotifications()
        setupDefaultSystemTags()

        return true
    }

    /**
    Add the default system tags that will be potentially used for segmentation
    */
    private func setupDefaultSystemTags() {

        let defaults = NSUserDefaults.standardUserDefaults()

        var userTags = defaults.objectForKey(CoreConstants.userDefaultsTagsKey) as? Dictionary<String,AnyObject> ?? Dictionary<String,AnyObject>()

        userTags[CoreConstants.tagPlatformNameKey] = "iOS"

        let version = NSProcessInfo.processInfo().operatingSystemVersion
        var versionString = "\(version.majorVersion).\(version.minorVersion)"

        if (version.patchVersion > 0) {
            versionString = versionString.stringByAppendingString(".\(version.patchVersion)")
        }

        userTags[CoreConstants.tagPlatformVersionKey] = versionString

        if let appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") {
            userTags[CoreConstants.tagApplicationNameKey] = appName
        }

        if let appVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") {
            userTags[CoreConstants.tagApplicationVersionKey] = appVersion
        }

        userTags[CoreConstants.tagDeviceManufacturerKey] = "Apple"
        userTags[CoreConstants.tagDeviceModelKey] = UIDevice.currentDevice().modelName
        userTags[CoreConstants.tagDeviceTypeKey] = UIDevice.currentDevice().deviceType

        let BLEsupported = (bluetoothManager.state != .Unsupported)

        userTags[CoreConstants.tagBLESupportKey] = BLEsupported
        userTags[CoreConstants.tagNFCSupportKey] = false

        let screen = UIScreen.mainScreen()
        let bounds = screen.bounds
        let (width, height) = (CGRectGetWidth(bounds) * screen.scale, round(CGRectGetHeight(bounds) * screen.scale))

        userTags[CoreConstants.tagDeviceScreenSizeKey] = "\(Int(width))x\(Int(height))"
        userTags[CoreConstants.tagTestDeviceKey] = (self.environment != .Prod)

        print(userTags)

        defaults.setObject(userTags, forKey: CoreConstants.userDefaultsTagsKey)
        defaults.synchronize()
    }

    /**
    Set up the desired push notifications to be received. To be called after the device has been
    registered
    
    - parameter application: Current application being configured to receive push notifications
    - parameter deviceToken: Device token returned after registering for push notifications
    */
    public func setupPushNotifications(application app: UIApplication, deviceToken: NSData) {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        app.registerUserNotificationSettings(settings)

        print("Push device token: \(deviceToken.description)")
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