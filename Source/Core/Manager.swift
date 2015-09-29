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

public enum HaloEnvironment: String {
    case Int, QA, Stage, Prod
}

public protocol ManagerDelegate {
    func setupUser() -> Halo.User
    func managerDidFinishLaunching() -> Void
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
    public var environment: HaloEnvironment = .Int {
        didSet {
            switch environment {
            case .Int:
                Router.baseURL = NSURL(string: "https://halo-int.mobgen.com")
            case .QA:
                Router.baseURL = NSURL(string: "https://halo-qa.mobgen.com")
            case .Stage:
                Router.baseURL = NSURL(string: "https://halo-stage.mobgen.com")
            case .Prod:
                Router.baseURL = NSURL(string: "https://halo.mobgen.com")
            }

            let defaults = NSUserDefaults.standardUserDefaults()

            defaults.setValue(environment.rawValue, forKey: CoreConstants.environmentKey)
            defaults.removeObjectForKey(CoreConstants.userDefaultsUserKey)
            self.user = Halo.User.loadUser(environment)
            self.launch()
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
    
    /// Delegate that will handle launching completion and other important steps in the flow
    public var delegate: ManagerDelegate?
    
    private override init() {
    }

    /**
    Perform the initial tasks to properly set up the SDK

    - returns Bool describing whether the process has succeeded
    */
    public func launch() -> Bool {

        Router.token = nil
        
        let bundle = NSBundle.mainBundle()
        if let path = bundle.pathForResource("Halo", ofType: "plist") {

            if let data = NSDictionary(contentsOfFile: path) {
                self.net.clientId = data[CoreConstants.clientIdKey] as? String
                self.net.clientSecret = data[CoreConstants.clientSecret] as? String
            }
        }

        if let cId = self.net.clientId, let secret = self.net.clientSecret {
            NSLog("Using client ID: \(cId) and client secret: \(secret)")
        }

        if let user = self.user {
            // Update the user
            net.getUser(user) { (result) -> Void in
                switch result {
                case .Success(let user):
                    self.user = user
                    UIApplication.sharedApplication().registerForRemoteNotifications()
                case .Failure(let error):
                    NSLog("Error: \(error.localizedDescription)")
                }
            }
            
        } else {
            self.user = delegate?.setupUser()
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
        
        return true
    }

    /**
    Add the default system tags that will be potentially used for segmentation
    */
    private func setupDefaultSystemTags() {

        if let user = self.user {

            user.addTag(CoreConstants.tagPlatformNameKey, value: "ios")

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

            NSLog(user.description)
            self.user?.storeUser(self.environment)

            self.net.createUpdateUser(user, completionHandler: { [weak self] (result) -> Void in
                
                if let strongSelf = self {
                    switch result {
                    case .Success(let user):
                        strongSelf.user = user
                        NSLog((strongSelf.user?.description)!)
                        strongSelf.user?.storeUser(strongSelf.environment)
                    case .Failure(let error):
                        NSLog("Error: \(error.localizedDescription)")
                    }
                
                    strongSelf.delegate?.managerDidFinishLaunching()
                
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

        let token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>")).stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let device = UserDevice(platform: "ios", token: token)
        self.user?.devices = [device]

        NSLog("Push device token: \(deviceToken.description)")
        
        self.setupDefaultSystemTags()
        
    }

    /**
    Get a list of the existing modules for the provided client credentials

    - parameter completionHandler:  Closure to be executed when the request has finished
    */
    public func getModules(completionHandler handler: (Alamofire.Result<[Halo.Module], NSError>) -> Void) -> Void {
        net.getModules(completionHandler: handler)
    }

    /**
    Save the current user. Calling this function will trigger an update of the user in the server

    :param: handler Closure to be executed once the request has finished
    */
    public func saveUser(completionHandler handler: (Alamofire.Result<Halo.User, NSError> -> Void)? = nil) -> Void {
        if let user = self.user {
            self.net.createUpdateUser(user, completionHandler: handler)
        }
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
            case .Failure(let error):
                failure?(error: error)
            }
        }
    }

    @objc(saveUser:failure:)
    public func saveUserFromObjC(success: ((userData: Halo.User) -> Void)?, failure: ((error: NSError) -> Void)?) {

        self.saveUser { (result) -> Void in

            switch result {
            case .Success(let user):
                success?(userData: user)
            case .Failure(let error):
                failure?(error: error)
            }
        }

    }
}