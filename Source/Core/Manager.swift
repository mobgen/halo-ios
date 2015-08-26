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
    let net = Halo.NetworkManager.instance

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

    /// Client id to be used in the API calls
    public var clientId: String? {
        get {
            return net.clientId
        }
        set {
            net.clientId = newValue
        }
    }

    /// Client secret to be used in the API calls
    public var clientSecret: String? {
        get {
            return net.clientSecret
        }
        set {
            net.clientSecret = newValue
        }
    }

    /// Instance holding all the user-related information
    public var user:User?

    private override init() {
        self.environment = .Prod

        // Get the stored user
        self.user = Halo.User.loadUser() ?? Halo.User(id: nil, appId: nil, alias: "defaultAlias")
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

        if let user = self.user {

            user.addTag(CoreConstants.tagPlatformNameKey, value: "iOS")

            let version = NSProcessInfo.processInfo().operatingSystemVersion
            var versionString = "\(version.majorVersion).\(version.minorVersion)"

            if (version.patchVersion > 0) {
                versionString = versionString.stringByAppendingString(".\(version.patchVersion)")
            }

            user.addTag(CoreConstants.tagPlatformVersionKey, value: versionString)

            if let appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") {
                user.addTag(CoreConstants.tagApplicationNameKey, value: appName.description)
            }

            if let appVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") {
                user.addTag(CoreConstants.tagApplicationVersionKey, value: appVersion.description)
            }

            user.addTag(CoreConstants.tagDeviceManufacturerKey, value: "Apple")
            user.addTag(CoreConstants.tagDeviceModelKey, value: UIDevice.currentDevice().modelName)
            user.addTag(CoreConstants.tagDeviceTypeKey, value: UIDevice.currentDevice().deviceType)

            let BLEsupported = (bluetoothManager.state != .Unsupported)

            user.addTag(CoreConstants.tagBLESupportKey, value: String(BLEsupported))
            user.addTag(CoreConstants.tagNFCSupportKey, value: "false")

            let screen = UIScreen.mainScreen()
            let bounds = screen.bounds
            let (width, height) = (CGRectGetWidth(bounds) * screen.scale, round(CGRectGetHeight(bounds) * screen.scale))

            user.addTag(CoreConstants.tagDeviceScreenSizeKey, value: "\(Int(width))x\(Int(height))")
            user.addTag(CoreConstants.tagTestDeviceKey, value: String(self.environment != .Prod))

            print(user.description)
            self.user?.storeUser()

            net.createUpdateUser(user, completionHandler: { (result) -> Void in
                switch result {
                case .Success(let user):
                    self.user = user
                    print(self.user?.description)
                    self.user?.storeUser()
                case .Failure(_, let error):
                    let err = error as NSError
                    print("Error: \(err.localizedDescription)")
                }
            })

        }
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

        let device = UserDevice(platform: "iOS", token: deviceToken.description)
        self.user?.devices = [device]

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
                let err = error as NSError
                failure?(error: err)
            }
        }
    }
}