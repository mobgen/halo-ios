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

@objc
public enum OfflinePolicy: Int {
    case None
    case LoadAndStoreLocalData
    case ReturnLocalDataDontLoad
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
    optional func setupUser(user: Halo.User) -> Void
    
    /**
     This delegate method will be called after the whole setup process has finished. Once it is safe
     to perform any operation involving the SDK.
     
     */
    func managerDidFinishLaunching() -> Void
}

/// Core manager of the Framework implemented as a Singleton
@objc(HaloManager)
public class Manager: NSObject, GGLInstanceIDDelegate {

    /// Shared instance of the manager (Singleton pattern)
    public static let sharedInstance = Halo.Manager()

    public var pushDelegate: PushDelegate?
    
    /// General content component
    public let generalContent = Halo.GeneralContent.sharedInstance

    public var defaultOfflinePolicy: OfflinePolicy = .LoadAndStoreLocalData
    
    public var numberOfRetries: Int {
        get {
            return self.net.numberOfRetries
        }
        set {
            self.net.numberOfRetries = newValue
        }
    }
    
    /// Singleton instance of the networking component
    let net = Halo.NetworkManager.instance
    
    let persist = Halo.PersistenceManager.sharedInstance

    /// Bluetooth manager to decide whether the device supports BLE
    private let bluetoothManager:CBCentralManager = CBCentralManager(delegate: nil, queue: nil)

    var gcmSenderId: String?
    
    private var deviceToken: NSData?
    
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

            // Setup the right realm
            persist.setupRealm(environment)
            
            defaults.setValue(environment.rawValue, forKey: CoreConstants.environmentKey)
            defaults.removeObjectForKey(CoreConstants.userDefaultsUserKey)
            self.launch()
        }
    }

    public var frameworkVersion: String {
        get {
            return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        }
    }
    
    public var credentials: Credentials? {
        get {
            return net.credentials
        }
        set {
            self.flushSession()
            net.credentials = newValue
        }
    }
    
    public var token: Token? {
        get {
            return Router.token
        }
    }
    
    public var debug: Bool {
        get {
            return net.debug
        }
        set {
            net.debug = newValue
        }
    }
    
    /// Variable to decide whether to enable push notifications or not
    public var enablePush: Bool = false

    /// Instance holding all the user-related information
    public var user:User?
    
    /// Delegate that will handle launching completion and other important steps in the flow
    public var delegate: ManagerDelegate?
    
    private override init() {}

    public func flushSession() {
        Router.token = nil
        Router.userAlias = nil
    }
    
    /**
     Extra setup steps to be called from the corresponding method in the app delegate
     
     - parameter application: Application being configured
     */
    public func applicationDidFinishLaunching(application: UIApplication) {
        
        var configureError:NSError?
        
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        Manager.sharedInstance.gcmSenderId = GGLContext.sharedInstance().configuration.gcmSenderID
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        
        let gcmConfig = GCMConfig.defaultConfig()
        GCMService.sharedInstance().startWithConfig(gcmConfig)
    }
    
    /**
     Extra setup steps to be called from the corresponding method in the app delegate
     
     - parameter application: Application being configured
     */
    public func applicationDidBecomeActive(application: UIApplication) {
        // Connect to the GCM server to receive non-APNS notifications
        GCMService.sharedInstance().connectWithHandler({
            (error) -> Void in
            if error != nil {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                print("Connected to GCM")
            }
        })
    }
    
    /**
     Extra setup steps to be called from the corresponding method in the app delegate
     
     - parameter application: Application being configured
     */
    public func applicationDidEnterBackground(application: UIApplication) {
        GCMService.sharedInstance().disconnect()
    }
    
    /**
    Perform the initial tasks to properly set up the SDK

    - returns: Bool describing whether the process has succeeded
    */
    public func launch() -> Void {

        Router.token = nil
        Router.userAlias = nil
        
        let bundle = NSBundle.mainBundle()
        
        if let path = bundle.pathForResource("Halo", ofType: "plist") {

            if let data = NSDictionary(contentsOfFile: path) {
                let clientIdKey = CoreConstants.clientIdKey
                let clientSecretKey = CoreConstants.clientSecretKey
                let usernameKey = CoreConstants.usernameKey
                let passwordKey = CoreConstants.passwordKey
                
                if let clientId = data[clientIdKey] as? String, clientSecret = data[clientSecretKey] as? String {
                    self.credentials = Credentials(clientId: clientId, clientSecret: clientSecret)
                } else if let username = data[usernameKey] as? String, password = data[passwordKey] as? String {
                    self.credentials = Credentials(username: username, password: password)
                }
                
                self.enablePush = (data[CoreConstants.enablePush] as? Bool) ?? false
            }
        } else {
            NSLog("No .plist found")
        }

        if let cred = self.net.credentials {
            NSLog("Using credentials: \(cred.username) / \(cred.password)")
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
                    self.setupDefaultSystemTags()
                }
            }
            
        } else {
            self.user = Halo.User()
            
            if let user = self.user {
                self.delegate?.setupUser?(user)
            }

            if self.enablePush {
                UIApplication.sharedApplication().registerForRemoteNotifications()
            } else {
                self.setupDefaultSystemTags()
            }
        }
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
        
        self.deviceToken = deviceToken
        
        //let token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>")).stringByReplacingOccurrencesOfString(" ", withString: "")

        // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
        
        if let senderId = self.gcmSenderId {
            
            // Start the GGLInstanceID shared instance with that config and request a registration
            // token to enable reception of notifications
            let gcm = GGLInstanceID.sharedInstance()
            
            let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
            instanceIDConfig.delegate = self
            // Start the GGLInstanceID shared instance with that config and request a registration
            // token to enable reception of notifications
            gcm.startWithConfig(instanceIDConfig)
            
            let registrationOptions = [
                kGGLInstanceIDRegisterAPNSOption: deviceToken,
                kGGLInstanceIDAPNSServerTypeSandboxOption: true
            ]
            
            gcm.tokenWithAuthorizedEntity(senderId, scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: { (token, error) -> Void in
                let device = UserDevice(platform: "ios", token: token)
                self.user?.devices = [device]
                
                NSLog("Push device token: \(token)")
                
                self.setupDefaultSystemTags()
            })
        } else {
            self.setupDefaultSystemTags()
        }
    }

    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        self.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: { (fetchResult) -> Void in })
    }
    
    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        
        self.pushDelegate?.haloApplication?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        
        if let silent = userInfo["content_available"] as? Int {
            if silent == 1 {
                self.pushDelegate?.haloApplication(application, didReceiveSilentNotification: userInfo, fetchCompletionHandler: completionHandler)
            } else {
                let notif = UILocalNotification()
                notif.alertBody = userInfo["body"] as? String
                notif.soundName = userInfo["sound"] as? String
                notif.userInfo = userInfo
                
                application.presentLocalNotificationNow(notif)
            }
        } else {
            self.pushDelegate?.haloApplication(application, didReceiveNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
    
    public func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        if let userInfo = notification.userInfo {
            self.pushDelegate?.haloApplication(application, didReceiveNotification: userInfo, fetchCompletionHandler: nil)
        }
    }
    
    // GGLInstanceIDDelegate methods
    
    public func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
        
        if let senderId = self.gcmSenderId, devToken = self.deviceToken {
            
            let registrationOptions = [
                kGGLInstanceIDRegisterAPNSOption: devToken,
                kGGLInstanceIDAPNSServerTypeSandboxOption: true
            ]
            
            GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(senderId,
                scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: { (token, error) -> Void in
                    let device = UserDevice(platform: "ios", token: token)
                    self.user?.devices = [device]
                    
                    if let currentUser = self.user {
                        self.net.createUpdateUser(currentUser)
                    }
            })
        }
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
    public func customRequest(method method: Alamofire.Method, url: String, params: [String: AnyObject]?,
        completionHandler handler: (Alamofire.Result<AnyObject, NSError>) -> Void) -> Void {
            net.haloRequest(method, url: url, params: params, completionHandler: handler)
    }
    
    // MARK: ObjC exposed methods

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
    @objc(customRequestWithMethod:url:params:success:failure:)
    public func customRequestFromObjC(method: String, url: String, params: [String: AnyObject]?,
        success: ((userData: AnyObject) -> Void)?, failure: ((error: NSError) -> Void)?) -> Void {
   
            self.customRequest(method: Alamofire.Method(rawValue: method.uppercaseString)!,
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