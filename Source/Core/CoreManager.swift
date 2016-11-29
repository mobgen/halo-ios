//
//  CoreManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 29/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

@objc(HaloCoreManager)
open class CoreManager: NSObject, HaloManager {

    private lazy var __once: (CoreManager, @escaping ((Bool) -> Void)) -> Void = { manager, handler in

            manager.completionHandler = handler
            Router.userToken = nil
            Router.appToken = nil

            Manager.network.startup { (success) -> Void in

                if (!success) {
                    handler(false)
                    return
                }

                let bundle = Bundle.main

                if let path = bundle.path(forResource: manager.configuration, ofType: "plist") {

                    if let data = NSDictionary(contentsOfFile: path) {
                        let clientIdKey = CoreConstants.clientIdKey
                        let clientSecretKey = CoreConstants.clientSecretKey
                        let usernameKey = CoreConstants.usernameKey
                        let passwordKey = CoreConstants.passwordKey
                        let environmentKey = CoreConstants.environmentSettingKey

                        if let clientId = data[clientIdKey] as? String, let clientSecret = data[clientSecretKey] as? String {
                            manager.appCredentials = Credentials(clientId: clientId, clientSecret: clientSecret)
                        }

                        if let username = data[usernameKey] as? String, let password = data[passwordKey] as? String {
                            manager.userCredentials = Credentials(username: username, password: password)
                        }

                        if let env = data[environmentKey] as? String {
                            self.setEnvironment(env)
                        }

                        manager.enableSystemTags = (data[CoreConstants.enableSystemTags] as? Bool) ?? false
                    }
                } else {
                    LogMessage(message: "No .plist found", level: .warning).print()
                }
                
                // Check if there's a stored environment
                if let env = KeychainWrapper.standard.string(forKey: CoreConstants.environmentSettingKey) {
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
                        manager.completionHandler?(false)
                    }
                }
            }
        }

    /// Delegate that will handle launching completion and other important steps in the flow
    open var delegate: ManagerDelegate?

    open internal(set) var dataProvider: DataProvider = DataProviderManager.online

    ///
    open var logLevel: LogLevel = .warning

    /// Token used to make sure the startup process is done only once
    fileprivate var token: Int = 0

    ///
    fileprivate let lockQueue = DispatchQueue(label: "com.mobgen.halo.lockQueue", attributes: [])

    open fileprivate(set) var environment: HaloEnvironment = .prod {
        didSet {
            Router.baseURL = environment.baseUrl
            Router.userToken = nil
            Router.appToken = nil
        }
    }

    open var defaultOfflinePolicy: OfflinePolicy = .none {
        didSet {
            switch defaultOfflinePolicy {
            case .none: self.dataProvider = DataProviderManager.online
            case .loadAndStoreLocalData: self.dataProvider = DataProviderManager.onlineOffline
            case .returnLocalDataDontLoad: self.dataProvider = DataProviderManager.offline
            }
        }
    }

    open var numberOfRetries: Int = 0
    
    open var appCredentials: Credentials?
    open var userCredentials: Credentials?

    open var frameworkVersion: String {
        return Bundle(identifier: "com.mobgen.Halo")!.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    open var configuration = "Halo"

    /// Variable to decide whether to enable system tags or not
    open var enableSystemTags: Bool = false

    /// Instance holding all the user-related information
    open var device: Device?

    open fileprivate(set) var addons: [Halo.Addon] = []

    fileprivate var completionHandler: ((Bool) -> Void)?

    override init() {}

    /**
     Allows changing the current environment against which the connections are made. It will imply a setup process again
     and that is why a completion handler can be provided. Once the process has finished and the environment is
     properly configured, it will be called.

     - parameter environment:   The new environment to be set
     - parameter handler:       Closure to be executed once the setup is done again and the environment is properly configured
     */
    open func setEnvironment(environment env: HaloEnvironment, completionHandler handler: ((Bool) -> Void)? = nil) {
        self.environment = env
        
        // Save the environment
        KeychainWrapper.standard.set(env.description, forKey: CoreConstants.environmentSettingKey)
        
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

    fileprivate func setEnvironment(_ env: String) {
        switch env.lowercased() {
        case "int": self.environment = .int
        case "qa": self.environment = .qa
        case "prod": self.environment = .prod
        case "stage": self.environment = .stage
        default: self.environment = .custom(env)
        }
    }
    
    /**
     Allows registering an add-on within the Core Manager.

     - parameter addon: Add-on implementation
     */
    @objc(registerAddon:)
    open func registerAddon(addon a: Halo.Addon) -> Void {
        a.willRegisterAddon(haloCore: self)
        self.addons.append(a)
        a.didRegisterAddon(haloCore: self)
    }

    /**
     Function to be executed to start the configuration and setup process of the HALO Framework

     - parameter handler: Closure to be executed once the process has finished. The parameter will provide information about whether the process has succeeded or not
     */
    @objc(startup:)
    open func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {

        if (token != 0) {
            LogMessage(message: "Startup method is being called more than once. No side-effects are caused by this, but you should probably double check that.",
                       level: .warning).print()
        }

        self.__once(self, handler ?? { _ in })
    }

    fileprivate func setupAddons(completionHandler handler: @escaping ((Bool) -> Void)) -> Void {

        if self.addons.isEmpty {
            handler(true)
            return
        }

        var counter = 0

        self.addons.forEach { $0.setup(haloCore: self) { (addon, success) in

            if success {
                LogMessage(message: "Successfully set up the \(addon.addonName) addon", level: .info).print()
            } else {
                LogMessage(message: "There has been an error setting up the \(addon.addonName) addon", level: .info).print()
            }

            counter += 1

            if counter == self.addons.count {
                handler(true)
            }
            }
        }

    }

    fileprivate func startupAddons(completionHandler handler: @escaping ((Bool) -> Void)) -> Void {

        if self.addons.isEmpty {
            handler(true)
            return
        }

        var counter = 0

        self.addons.forEach { $0.startup(haloCore: self) { (addon, success) in

            if success {
                LogMessage(message: "Successfully started the \(addon.addonName) addon", level: .info).print()
            } else {
                LogMessage(message: "There has been an error starting the \(addon.addonName) addon", level: .info).print()
            }

            counter += 1

            if counter == self.addons.count {
                handler(true)
            }

            }
        }
    }

    fileprivate func configureDevice(completionHandler handler: ((Bool) -> Void)? = nil) {
        self.device = Halo.Device.loadDevice(env: self.environment)

        if let device = self.device , device.id != nil {
            // Update the user
            Manager.network.getDevice(device) { (_, result) -> Void in
                switch result {
                case .success(let device, _):
                    self.device = device

                    if self.enableSystemTags {
                        self.setupDefaultSystemTags(completionHandler: handler)
                    } else {
                        handler?(true)
                    }
                case .failure(let error):

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

    fileprivate func setupDefaultSystemTags(completionHandler handler: ((Bool) -> Void)? = nil) {

        if let device = self.device {

            device.addSystemTag(name: CoreConstants.tagPlatformNameKey, value: "ios")

            let version = ProcessInfo.processInfo.operatingSystemVersion
            var versionString = "\(version.majorVersion).\(version.minorVersion)"

            if (version.patchVersion > 0) {
                versionString = versionString + ".\(version.patchVersion)"
            }

            device.addSystemTag(name: CoreConstants.tagPlatformVersionKey, value: versionString)

            if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") {
                device.addSystemTag(name: CoreConstants.tagApplicationNameKey, value: (appName as AnyObject).description)
            }

            if let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
                device.addSystemTag(name: CoreConstants.tagApplicationVersionKey, value: (appVersion as AnyObject).description)
            }

            device.addSystemTag(name: CoreConstants.tagDeviceManufacturerKey, value: "Apple")
            device.addSystemTag(name: CoreConstants.tagDeviceModelKey, value: UIDevice.current.modelName)
            device.addSystemTag(name: CoreConstants.tagDeviceTypeKey, value: UIDevice.current.deviceType)

            device.addSystemTag(name: CoreConstants.tagBLESupportKey, value: "true")

            //user.addTag(CoreConstants.tagNFCSupportKey, value: "false")

            let screen = UIScreen.main
            let bounds = screen.bounds
            let (width, height) = (bounds.width * screen.scale, round(bounds.height * screen.scale))

            device.addSystemTag(name: CoreConstants.tagDeviceScreenSizeKey, value: "\(Int(width))x\(Int(height))")

            switch self.environment {
            case .int, .stage, .qa:
                device.addSystemTag(name: CoreConstants.tagTestDeviceKey, value: "true")
            default:
                break
            }

            // Get APNs environment
            device.addSystemTag(name: "apns", value: MobileProvisionParser.applicationReleaseMode().rawValue.lowercased())

            handler?(true)
        } else {
            handler?(false)
        }

    }

    fileprivate func registerDevice() -> Void {

        if let device = self.device {
            self.device?.storeDevice(env: self.environment)

            self.addons.forEach { $0.willRegisterDevice(haloCore: self) }
            
            Manager.network.createUpdateDevice(device) { [weak self] (_, result) -> Void in

                var success = false

                if let strongSelf = self {

                    switch result {
                    case .success(let device, _):
                        strongSelf.device = device
                        strongSelf.device?.storeDevice(env: strongSelf.environment)

                        if let u = device {
                            LogMessage(message: u.description, level: .info).print()
                        }

                        success = true
                    case .failure(let error):
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
    open func saveDevice(completionHandler handler: ((HTTPURLResponse?, Halo.Result<Halo.Device?>) -> Void)? = nil) -> Void {

        /**
         *  Make sure no 'saveUser' are executed concurrently. That could lead to some inconsistencies in the server (several users
         *  created for the same device).
         */
        lockQueue.sync {

            if let device = self.device {

                Manager.network.createUpdateDevice(device) { [weak self] (response, result) in

                    if let strongSelf = self {

                        switch result {
                        case .success(let device, _):
                            strongSelf.device = device

                            if let u = device {
                                LogMessage(message: u.description, level: .info).print()
                            }

                        case .failure(let error):
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
    open func authenticate(authMode mode: Halo.AuthenticationMode = .app, completionHandler handler: ((HTTPURLResponse?, Halo.Result<Halo.Token>) -> Void)? = nil) -> Void {
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
    open func application(application app: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        LogMessage(message: "Successfully registered for remote notifications with token \(deviceToken)", level: .info).print()

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
    open func application(application app: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {

        LogMessage(message: "Failed registering for remote notifications", error: error).print()

        self.addons.forEach { (addon) in
            if let notifAddon = addon as? Halo.NotificationsAddon {
                notifAddon.application(application: app, didFailToRegisterForRemoteNotificationsWithError: error, core: self)
            }
        }
    }

    @objc(application:didReceiveRemoteNotification:userInteraction:)
    open func application(application app: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], userInteraction user: Bool) {
        
        self.addons.forEach { (addon) in
            if let notifAddon = addon as? Halo.NotificationsAddon {
                notifAddon.application(application: app, didReceiveRemoteNotification: userInfo, core: self, userInteraction: user, fetchCompletionHandler: { _ in })
            }
        }
    }

    @objc(application:didReceiveRemoteNotification:userInteraction:fetchCompletionHandler:)
    open func application(application app: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], userInteraction user: Bool, fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        self.addons.forEach { (addon) in
            if let notifAddon = addon as? Halo.NotificationsAddon {
                notifAddon.application(application: app, didReceiveRemoteNotification: userInfo, core: self, userInteraction: user, fetchCompletionHandler: completionHandler)
            }
        }
    }

    @objc(applicationDidBecomeActive:)
    open func applicationDidBecomeActive(application app: UIApplication) {
        self.addons.forEach { $0.applicationDidBecomeActive(app, core: self) }
    }

    @objc(applicationDidEnterBackground:)
    open func applicationDidEnterBackground(application app: UIApplication) {
        self.addons.forEach { $0.applicationDidEnterBackground(app, core: self) }
    }

    open func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return self.addons.reduce(false) { $0 || $1.application(app, open: url, options: options) }
    }
    
    open func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return self.addons.reduce(false) { $0 || $1.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) }
    }
    
    fileprivate func checkNeedsUpdate(completionHandler handler: ((Bool) -> Void)? = nil) -> Void {

        try! Request<Any>(router: .versionCheck).response { (_, result) in
            switch result {
            case .success(let data as [[String: AnyObject]], _):
                if let info = data.first, let minIOS = info["minIOS"] {
                    if minIOS.compare(self.frameworkVersion, options: .numeric) == .orderedDescending {
                        let changelog = info["iosChangeLog"] as! String

                        LogMessage(message: "The version of the Halo SDK you are using is outdated. Please update to ensure there are no breaking changes. Minimum version: \(minIOS). Version changelog: \(changelog)", level: .warning).print()
                    }
                }
                handler?(true)
            case .failure(_):
                handler?(false)
            default:
                break
            }
        }
    }

}
