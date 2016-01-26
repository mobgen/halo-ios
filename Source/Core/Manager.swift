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

/**
Enumeration holding the different environment options available

- Int:   Integration environment
- QA:    QA environment
- Stage: Stage environment
- Prod:  Production environment
*/
public enum HaloEnvironment: String {
    case Int
    case QA
    case Stage
    case Prod
}

/**
This delegate will provide methods that will act as interception points in the setup process of the SDK
within the application
 */
@objc(HaloManagerDelegate)
public protocol ManagerDelegate {

    /**
     This delegate method provides full freedom to create the user that will be registered by the application.
     
     - returns: The newly created user
     */
    func setupUser() -> Halo.User
    
    /**
     This delegate method will be called after the whole setup process has finished. Once it is safe
     to perform any operation involving the SDK.
     
     */
    func managerDidFinishLaunching() -> Void
}

/// Core manager of the Framework implemented as a Singleton
@objc(HaloManager)
public class Manager: NSObject {

    /// Shared instance of the manager (Singleton pattern)
    public static let sharedInstance = Halo.Manager()

    public var pushDelegate: HaloPushDelegate?
    
    /// General content component
    public let generalContent = Halo.GeneralContent.sharedInstance

    /// Singleton instance of the networking component
    let net = Halo.NetworkManager.instance

    /// Bluetooth manager to decide whether the device supports BLE
    private let bluetoothManager:CBCentralManager = CBCentralManager(delegate: nil, queue: nil)

    /// Current environment (QA, Integration or Prod)
    public var environment: HaloEnvironment = .Prod {
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

    /// Variable to decide whether to enable push notifications or not
    public var enablePush: Bool = false

    /// Instance holding all the user-related information
    public var user:User?
    
    /// Delegate that will handle launching completion and other important steps in the flow
    public var delegate: ManagerDelegate?
    
    private override init() {}

    /**
    Perform the initial tasks to properly set up the SDK

    - returns: Bool describing whether the process has succeeded
    */
    public func launch() -> Bool {

        Router.token = nil
        Router.userAlias = nil
        
        let bundle = NSBundle.mainBundle()
        if let path = bundle.pathForResource("Halo", ofType: "plist") {

            if let data = NSDictionary(contentsOfFile: path) {
                let clientIdKey = CoreConstants.clientIdKey
                let clientSecretKey = CoreConstants.clientSecretKey
                
                self.net.clientId = data[clientIdKey] as? String
                self.net.clientSecret = data[clientSecretKey] as? String
                self.enablePush = (data[CoreConstants.enablePush] as? Bool) ?? false
            }
        } else {
            NSLog("No .plist found")
        }

        if let cId = self.net.clientId, let secret = self.net.clientSecret {
            NSLog("Using client ID: \(cId) and client secret: \(secret)")
        }

        self.user = Halo.User.loadUser(self.environment)
        
        if let user = self.user {
            // Update the user
            net.getUser(user) { (result) -> Void in
                switch result {
                case .Success(let user):
                    self.user = user

                    if self.enablePush {
                        UIApplication.sharedApplication().registerForRemoteNotifications()
                    } else {
                        self.setupDefaultSystemTags()
                    }
                case .Failure(let error):
                    NSLog("Error: \(error.localizedDescription)")
                }
            }
            
        } else {
            self.user = self.delegate?.setupUser()

            if self.enablePush {
                UIApplication.sharedApplication().registerForRemoteNotifications()
            } else {
                self.setupDefaultSystemTags()
            }
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
            
            if BLEsupported {
                user.addTag(CoreConstants.tagBLESupportKey, value: nil)
            }
            
            //user.addTag(CoreConstants.tagNFCSupportKey, value: "false")

            let screen = UIScreen.mainScreen()
            let bounds = screen.bounds
            let (width, height) = (CGRectGetWidth(bounds) * screen.scale, round(CGRectGetHeight(bounds) * screen.scale))

            user.addTag(CoreConstants.tagDeviceScreenSizeKey, value: "\(Int(width))x\(Int(height))")
            
            if (self.environment != .Prod) {
                user.addTag(CoreConstants.tagTestDeviceKey, value: nil)
            }

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
                
                    if let alias = strongSelf.user!.alias {
                        Router.userAlias = alias
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
    private func setupPushNotifications(application app: UIApplication, deviceToken: NSData) {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        app.registerUserNotificationSettings(settings)

        let token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>")).stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let device = UserDevice(platform: "ios", token: token)
        self.user?.devices = [device]

        NSLog("Push device token: \(deviceToken.description)")
        
        self.setupDefaultSystemTags()
        
    }

    /**
     Pass through the push notifications setup. To be called within the method in the app delegate.
     
     - parameter application: Application being configured
     - parameter deviceToken: Token obtained for the current device
     */
    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        self.setupPushNotifications(application: application, deviceToken: deviceToken)
    }

    /**
     Pass through the push notifications setup. To be called within the method in the app delegate.
     
     - parameter application: Application being configured
     - parameter error:       Error thrown during the process
     */
    public func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
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

    - parameter completionHandler: Closure to be executed once the request has finished
    */
    public func saveUser(completionHandler handler: (Alamofire.Result<Halo.User, NSError> -> Void)? = nil) -> Void {
        if let user = self.user {
            self.net.createUpdateUser(user, completionHandler: handler)
        }
    }

    /**
     Use this method to create custom requests so that you can query your custom modules within Halo
     
     - parameter method:  Method to be used for the request (GET, POST, etc)
     - parameter url:     Custom url endpoint
     - parameter params:  Provided params provided
     - parameter handler: Closure to be executed after the request has finished
     */
    public func getHaloRequest(method method: Alamofire.Method, url: String, params: [String: AnyObject]?,
        completionHandler handler: (Alamofire.Result<AnyObject, NSError>) -> Void) -> Void {
            net.haloRequest(method, url: url, params: params, completionHandler: handler)
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

    /**
    Save the user against the server

    - parameter success: Closure to be executed when the request has succeeded
    - parameter failure: Closure to be executed when the request has failed
    */
    @objc(saveUserWithSuccess:failure:)
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
    
    /**
    Perform a custom request from Objective-C
    
    - parameter method:  Method of the request (GET, POST, PUT, etc)
    - parameter url:     Custom endpoint to be accessed
    - parameter params:  Parameters provided for the current request
    - parameter success: Closure to be executed after the request has successfully finished
    - parameter failure: Closure to be executed after the request has failed
    */
    @objc(haloRequestWithMethod:url:params:success:failure:)
    public func getHaloRequestFromObjC(method: String, url: String, params: [String: AnyObject]?,
        success: ((userData: AnyObject) -> Void)?, failure: ((error: NSError) -> Void)?) -> Void {
   
            self.getHaloRequest(method: Alamofire.Method(rawValue: method.uppercaseString)!,
                url: url, params: params) { (result) -> Void in
                    switch result {
                    case .Success(let data):
                        success?(userData: data)
                    case .Failure(let error):
                        failure?(error: error)
                    }
            }
    }
}