//
//  CoreManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 29/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit

@objc(HaloCoreManager)
public class CoreManager: NSObject, HaloManager {

    /// Delegate that will handle launching completion and other important steps in the flow
    public var delegate: ManagerDelegate?

    public internal(set) var dataProvider: DataProvider = DataProviderManager.online

    ///
    public var logLevel: LogLevel = .Warning

    /// Token used to make sure the startup process is done only once
    private var token: dispatch_once_t = 0

    ///
    private let lockQueue = dispatch_queue_create("com.mobgen.halo.lockQueue", nil)

    public private(set) var environment: HaloEnvironment = .Prod {
        didSet {
            Router.baseURL = environment.baseUrl
            Router.userToken = nil
            Router.appToken = nil
        }
    }

    public var defaultOfflinePolicy: OfflinePolicy = .None {
        didSet {
            switch defaultOfflinePolicy {
            case .None: self.dataProvider = DataProviderManager.online
            case .LoadAndStoreLocalData: self.dataProvider = DataProviderManager.onlineOffline
            case .ReturnLocalDataDontLoad: self.dataProvider = DataProviderManager.offline
            }
        }
    }

    public var numberOfRetries: Int = 0
    
    public var appCredentials: Credentials?
    public var userCredentials: Credentials?

    public var frameworkVersion: String {
        return NSBundle(identifier: "com.mobgen.Halo")!.objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }

    public var configuration = "Halo"

    /// Variable to decide whether to enable system tags or not
    public var enableSystemTags: Bool = false

    /// Instance holding all the user-related information
    public var device: Device?

    public private(set) var addons: [Halo.Addon] = []

    private var completionHandler: ((Bool) -> Void)?

    override init() {}

    /**
     Allows changing the current environment against which the connections are made. It will imply a setup process again
     and that is why a completion handler can be provided. Once the process has finished and the environment is
     properly configured, it will be called.

     - parameter environment:   The new environment to be set
     - parameter handler:       Closure to be executed once the setup is done again and the environment is properly configured
     */
    public func setEnvironment(environment env: HaloEnvironment, completionHandler handler: ((Bool) -> Void)? = nil) {
        self.environment = env
        
        // Save the environment
        NSUserDefaults.standardUserDefaults().setValue(env.description, forKey: CoreConstants.environmentSettingKey)
        
        self.completionHandler = handler
        self.configureDevice { success in
            if success {
                // Configure all the registered addons
                self.setupAddons { _ in
                    
                    self.startupAddons { _ in
                        self.registerDevice()
                    }
                }
            } else {
                handler?(false)
            }
        }
    }

    private func setEnvironment(env: String) {
        switch env.lowercaseString {
        case "int": self.environment = .Int
        case "qa": self.environment = .QA
        case "prod": self.environment = .Prod
        case "stage": self.environment = .Stage
        default: self.environment = .Custom(env)
        }
    }
    
    /**
     Allows registering an add-on within the Core Manager.

     - parameter addon: Add-on implementation
     */
    @objc(registerAddon:)
    public func registerAddon(addon a: Halo.Addon) -> Void {
        a.willRegisterAddon(haloCore: self)
        self.addons.append(a)
        a.didRegisterAddon(haloCore: self)
    }

    /**
     Function to be executed to start the configuration and setup process of the HALO Framework

     - parameter handler: Closure to be executed once the process has finished. The parameter will provide information about whether the process has succeeded or not
     */
    @objc(startup:)
    public func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {

        if (token != 0) {
            LogMessage(message: "Startup method is being called more than once. No side-effects are caused by this, but you should probably double check that.",
                       level: .Warning).print()
        }

        dispatch_once(&token) {

            self.completionHandler = handler
            Router.userToken = nil
            Router.appToken = nil

            Manager.network.startup { (success) -> Void in

                if (!success) {
                    handler?(false)
                    return
                }

                let bundle = NSBundle.mainBundle()

                if let path = bundle.pathForResource(self.configuration, ofType: "plist") {

                    if let data = NSDictionary(contentsOfFile: path) {
                        let clientIdKey = CoreConstants.clientIdKey
                        let clientSecretKey = CoreConstants.clientSecretKey
                        let usernameKey = CoreConstants.usernameKey
                        let passwordKey = CoreConstants.passwordKey
                        let environmentKey = CoreConstants.environmentSettingKey

                        if let clientId = data[clientIdKey] as? String, let clientSecret = data[clientSecretKey] as? String {
                            self.appCredentials = Credentials(clientId: clientId, clientSecret: clientSecret)
                        }

                        if let username = data[usernameKey] as? String, let password = data[passwordKey] as? String {
                            self.userCredentials = Credentials(username: username, password: password)
                        }

                        if let env = data[environmentKey] as? String {
                            self.setEnvironment(env)
                        }

                        self.enableSystemTags = (data[CoreConstants.enableSystemTags] as? Bool) ?? false
                    }
                } else {
                    LogMessage(message: "No .plist found", level: .Warning).print()
                }
                
                // Check if there's a stored environment
                if let env = NSUserDefaults.standardUserDefaults().objectForKey(CoreConstants.environmentSettingKey) as? String {
                    self.setEnvironment(env)
                }

                self.checkNeedsUpdate()

                self.configureDevice { success in

                    if success {
                        // Configure all the registered addons
                        self.setupAddons { _ in
                            
                            self.startupAddons { _ in
                                self.registerDevice()
                            }
                        }
                    } else {
                        self.completionHandler?(false)
                    }
                }
            }
        }
    }

    private func setupAddons(completionHandler handler: ((Bool) -> Void)) -> Void {

        if self.addons.isEmpty {
            handler(true)
            return
        }

        var counter = 0

        self.addons.forEach { $0.setup(haloCore: self) { (addon, success) in

            if success {
                LogMessage(message: "Successfully set up the \(addon.addonName) addon", level: .Info).print()
            } else {
                LogMessage(message: "There has been an error setting up the \(addon.addonName) addon", level: .Info).print()
            }

            counter += 1

            if counter == self.addons.count {
                handler(true)
            }
            }
        }

    }

    private func startupAddons(completionHandler handler: ((Bool) -> Void)) -> Void {

        if self.addons.isEmpty {
            handler(true)
            return
        }

        var counter = 0

        self.addons.forEach { $0.startup(haloCore: self) { (addon, success) in

            if success {
                LogMessage(message: "Successfully started the \(addon.addonName) addon", level: .Info).print()
            } else {
                LogMessage(message: "There has been an error starting the \(addon.addonName) addon", level: .Info).print()
            }

            counter += 1

            if counter == self.addons.count {
                handler(true)
            }

            }
        }
    }

    private func configureDevice(completionHandler handler: ((Bool) -> Void)? = nil) {
        self.device = Halo.Device.loadDevice(env: self.environment)

        if let device = self.device where device.id != nil {
            // Update the user
            Manager.network.getDevice(device) { (_, result) -> Void in
                switch result {
                case .Success(let device, _):
                    self.device = device

                    if self.enableSystemTags {
                        self.setupDefaultSystemTags(completionHandler: handler)
                    } else {
                        handler?(true)
                    }
                case .Failure(let error):

                    LogMessage(message: "Error retrieving user from server", error: error).print()

                    if self.enableSystemTags {
                        self.setupDefaultSystemTags(completionHandler: handler)
                    } else {
                        handler?(false)
                    }
                }
            }

        } else {
            self.device = Halo.Device()
            self.delegate?.managerWillSetupDevice(self.device!)

            if self.enableSystemTags {
                self.setupDefaultSystemTags(completionHandler: handler)
            } else {
                handler?(true)
            }
        }
    }

    private func setupDefaultSystemTags(completionHandler handler: ((Bool) -> Void)? = nil) {

        if let device = self.device {

            device.addSystemTag(name: CoreConstants.tagPlatformNameKey, value: "ios")

            let version = NSProcessInfo.processInfo().operatingSystemVersion
            var versionString = "\(version.majorVersion).\(version.minorVersion)"

            if (version.patchVersion > 0) {
                versionString = versionString.stringByAppendingString(".\(version.patchVersion)")
            }

            device.addSystemTag(name: CoreConstants.tagPlatformVersionKey, value: versionString)

            if let appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") {
                device.addSystemTag(name: CoreConstants.tagApplicationNameKey, value: appName.description)
            }

            if let appVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") {
                device.addSystemTag(name: CoreConstants.tagApplicationVersionKey, value: appVersion.description)
            }

            device.addSystemTag(name: CoreConstants.tagDeviceManufacturerKey, value: "Apple")
            device.addSystemTag(name: CoreConstants.tagDeviceModelKey, value: UIDevice.currentDevice().modelName)
            device.addSystemTag(name: CoreConstants.tagDeviceTypeKey, value: UIDevice.currentDevice().deviceType)

            device.addSystemTag(name: CoreConstants.tagBLESupportKey, value: "true")

            //user.addTag(CoreConstants.tagNFCSupportKey, value: "false")

            let screen = UIScreen.mainScreen()
            let bounds = screen.bounds
            let (width, height) = (CGRectGetWidth(bounds) * screen.scale, round(CGRectGetHeight(bounds) * screen.scale))

            device.addSystemTag(name: CoreConstants.tagDeviceScreenSizeKey, value: "\(Int(width))x\(Int(height))")

            switch self.environment {
            case .Int, .Stage, .QA:
                device.addSystemTag(name: CoreConstants.tagTestDeviceKey, value: "true")
            default:
                break
            }

            // Get APNs environment
            device.addSystemTag(name: "apns", value: MobileProvisionParser.applicationReleaseMode().rawValue.lowercaseString)

            handler?(true)
        } else {
            handler?(false)
        }

    }

    private func registerDevice() -> Void {

        if let device = self.device {
            self.device?.storeDevice(env: self.environment)

            self.addons.forEach { $0.willRegisterDevice(haloCore: self) }
            
            Manager.network.createUpdateDevice(device) { [weak self] (_, result) -> Void in

                var success = false

                if let strongSelf = self {

                    switch result {
                    case .Success(let device, _):
                        strongSelf.device = device
                        strongSelf.device?.storeDevice(env: strongSelf.environment)

                        if let u = device {
                            LogMessage(message: u.description, level: .Info).print()
                        }

                        success = true
                    case .Failure(let error):
                        LogMessage(message: "Error creating/updating user", error: error).print()
                    }

                    strongSelf.addons.forEach { $0.didRegisterDevice(haloCore: strongSelf) }
                    strongSelf.completionHandler?(success)

                }
            }
        } else {
            self.completionHandler?(false)
        }
    }

    /**
     By calling this function, the current user handled by the Core Manager will be saved in the server.

     - parameter handler: Closure to be executed once the request has finished, providing a result.
     */
    public func saveDevice(completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<Halo.Device?>) -> Void)? = nil) -> Void {

        /**
         *  Make sure no 'saveUser' are executed concurrently. That could lead to some inconsistencies in the server (several users
         *  created for the same device).
         */
        dispatch_sync(lockQueue) {

            if let device = self.device {

                Manager.network.createUpdateDevice(device) { [weak self] (response, result) in

                    if let strongSelf = self {

                        switch result {
                        case .Success(let device, _):
                            strongSelf.device = device

                            if let u = device {
                                LogMessage(message: u.description, level: .Info).print()
                            }

                        case .Failure(let error):
                            LogMessage(message: "Error saving user", error: error).print()
                        }

                        handler?(response, result)

                    }

                }
            }
        }
    }

    /**
     Authenticate against the server using the provided mode and the stored credentials. No authentication is needed under normal
     circumnstances. The system will take care of everything, but this could become handy if the authentication wants to be forced for
     some reason.

     - parameter mode:    Authentication mode to be used
     - parameter handler: Closure to be executed once the authentication has finished
     */
    public func authenticate(authMode mode: Halo.AuthenticationMode = .App, completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<Halo.Token>) -> Void)? = nil) -> Void {
        Manager.network.authenticate(mode: mode) { (response, result) in
            handler?(response, result)
        }
    }

    /**
     Pass through the push notifications setup. To be called within the method in the app delegate.

     - parameter application: Application being configured
     - parameter deviceToken: Token obtained for the current device
     */
    @objc(application:didRegisterForRemoteNotificationsWithDeviceToken:)
    public func application(application app: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {

        LogMessage(message: "Successfully registered for remote notifications with token \(deviceToken)", level: .Info).print()

        self.addons.forEach { (addon) in
            if let notifAddon = addon as? Halo.NotificationsAddon {
                notifAddon.application(application: app, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken, core: self)
            }
        }
    }

    /**
     Pass through the push notifications setup. To be called within the method in the app delegate.

     - parameter application: Application being configured
     - parameter error:       Error thrown during the process
     */
    @objc(application:didFailToRegisterForRemoteNotificationsWithError:)
    public func application(application app: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {

        LogMessage(message: "Failed registering for remote notifications", error: error).print()

        self.addons.forEach { (addon) in
            if let notifAddon = addon as? Halo.NotificationsAddon {
                notifAddon.application(application: app, didFailToRegisterForRemoteNotificationsWithError: error, core: self)
            }
        }
    }

    @objc(application:didReceiveRemoteNotification:userInteraction:)
    public func application(application app: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], userInteraction user: Bool) {
        
        self.addons.forEach { (addon) in
            if let notifAddon = addon as? Halo.NotificationsAddon {
                notifAddon.application(application: app, didReceiveRemoteNotification: userInfo as [NSObject : AnyObject], core: self, userInteraction: user, fetchCompletionHandler: { _ in })
            }
        }
        
    }

    @objc(application:didReceiveRemoteNotification:userInteraction:fetchCompletionHandler:)
    public func application(application app: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], userInteraction user: Bool, fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {

        self.addons.forEach { (addon) in
            if let notifAddon = addon as? Halo.NotificationsAddon {
                notifAddon.application(application: app, didReceiveRemoteNotification: userInfo, core: self, userInteraction: user, fetchCompletionHandler: completionHandler)
            }
        }
    }

    @objc(applicationDidBecomeActive:)
    public func applicationDidBecomeActive(application app: UIApplication) {
        self.addons.forEach { $0.applicationDidBecomeActive(application: app, core: self) }
    }

    @objc(applicationDidEnterBackground:)
    public func applicationDidEnterBackground(application app: UIApplication) {
        self.addons.forEach { $0.applicationDidEnterBackground(application: app, core: self) }
    }

    private func checkNeedsUpdate(completionHandler handler: ((Bool) -> Void)? = nil) -> Void {

        try! Request<Any>(path: "/api/authentication/version").params(params: ["current": "true"]).response { (_, result) in
            switch result {
            case .Success(let data as [[String: AnyObject]], _):
                if let info = data.first, let minIOS = info["minIOS"] {
                    if minIOS.compare(self.frameworkVersion, options: .NumericSearch) == .OrderedDescending {
                        let changelog = info["iosChangeLog"] as! String

                        LogMessage(message: "The version of the Halo SDK you are using is outdated. Please update to ensure there are no breaking changes. Minimum version: \(minIOS). Version changelog: \(changelog)", level: .Warning).print()
                    }
                }
                handler?(true)
            case .Failure(_):
                handler?(false)
            default:
                break
            }
        }

    }

}
