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
open class CoreManager: NSObject, HaloManager, Logger {
    
    private lazy var __once: (CoreManager, ((Bool) -> Void)?) -> Void = { mgr, handler in
        
        mgr.completionHandler = { success in
            mgr.isReady = success
            Halo.Manager.network.restartCachedTasks()
            handler?(success)
        }
        
        Router.userToken = nil
        Router.appToken = nil
        
        Manager.network.startup { success in
            
            if !success {
                mgr.completionHandler?(false)
                return
            }
            
            let bundle = Bundle.main
            
            if let path = bundle.path(forResource: mgr.configuration, ofType: "plist") {
                
                if let data = NSDictionary(contentsOfFile: path) {
                    let clientIdKey = CoreConstants.clientIdKey
                    let clientSecretKey = CoreConstants.clientSecretKey
                    let usernameKey = CoreConstants.usernameKey
                    let passwordKey = CoreConstants.passwordKey
                    let environmentKey = CoreConstants.environmentSettingKey
                    
                    if let clientId = data[clientIdKey] as? String, let clientSecret = data[clientSecretKey] as? String {
                        mgr.appCredentials = Credentials(clientId: clientId, clientSecret: clientSecret)
                    }
                    
                    if let username = data[usernameKey] as? String, let password = data[passwordKey] as? String {
                        mgr.userCredentials = Credentials(username: username, password: password)
                    }
                    
                    if let tags = data[CoreConstants.enableSystemTags] as? Bool {
                        mgr.enableSystemTags = tags
                    }
                    
                    if let env = data[environmentKey] as? String {
                        mgr.setEnvironment(env)
                    }
                }
            } else {
                self.logMessage(message: "No configuration .plist found", level: .warning)
            }
            
            self.checkNeedsUpdate()
            self.setup(manager: mgr)
        }
    }
    
    /// Delegate that will handle launching completion and other important steps in the flow
    public var delegate: ManagerDelegate?
    
    public internal(set) var loggers: [Logger] = []
    
    public internal(set) var isReady: Bool = false
    
    public internal(set) var dataProvider: DataProvider = DataProviderManager.online
    
    ///
    public var logLevel: LogLevel = .warning
    
    ///
    let lockQueue = DispatchQueue(label: "com.mobgen.halo.lockQueue", attributes: [])
    
    public fileprivate(set) var environment: HaloEnvironment = .prod {
        didSet {
            Router.baseURL = environment.baseUrl
            Router.userToken = nil
            Router.appToken = nil
        }
    }
    
    public var defaultOfflinePolicy: OfflinePolicy = .none {
        didSet {
            switch defaultOfflinePolicy {
            case .none: self.dataProvider = DataProviderManager.online
            case .loadAndStoreLocalData: self.dataProvider = DataProviderManager.onlineOffline
            case .returnLocalDataDontLoad: self.dataProvider = DataProviderManager.offline
            }
        }
    }
    
    public var defaultAuthenticationMode: AuthenticationMode = .app
    
    open var numberOfRetries: Int = 0
    
    public var appCredentials: Credentials?
    public var userCredentials: Credentials?
    
    public var frameworkVersion: String {
        return Bundle(identifier: "com.mobgen.Halo")!.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    public var configuration = "Halo"
    
    /// Variable to decide whether to enable system tags or not
    public var enableSystemTags: Bool = false
    
    /// Instance holding all the device-related information
    public var device: Device?
    
    public internal(set) var addons: [Halo.Addon] = []
    
    fileprivate var completionHandler: ((Bool) -> Void)?
    
    fileprivate override init() {
        super.init()
    }
    
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
        KeychainHelper.set(env.description, forKey: CoreConstants.environmentSettingKey)
        
        self.completionHandler = handler
        self.setup(manager: self)
    }
    
    fileprivate func setup(manager: CoreManager) {
        
        let handler: (Bool) -> Void = { success in
            
            if !success {
                manager.completionHandler?(false)
                return
            }
            
            if let authProfile = AuthProfile.loadProfile(env: manager.environment) {
                // Login and get user details (in case there have been updates)
                Manager.auth.login(authProfile: authProfile, stayLoggedIn: true) { _, error in
                    manager.completionHandler?(error == nil)
                    return
                }
            }
            
            manager.completionHandler?(true)
        }
        
        // Configure device
        manager.configureDevice { success in
            if success {
                // Configure all the registered addons
                manager.setupAndStartAddons { success in
                    if success {
                        manager.registerDevice { success in
                            handler(success)
                            return
                        }
                    } else {
                        handler(false)
                        return
                    }
                }
            } else {
                handler(false)
                return
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
        
        // Save the environment
        KeychainHelper.set(self.environment.description, forKey: CoreConstants.environmentSettingKey)
    }
    
    @objc(startup:)
    public func startup(completionHandler handler: ((Bool) -> Void)? = nil) {
                
        // Check if there's a stored environment
        if let env = KeychainHelper.string(forKey: CoreConstants.environmentSettingKey) {
            self.setEnvironment(env)
        }
        
        self.__once(self, handler)
        
    }
    
    /**
     Pass through the push notifications setup. To be called within the method in the app delegate.
     
     - parameter application: Application being configured
     - parameter deviceToken: Token obtained for the current device
     */
    @objc(application:didRegisterForRemoteNotificationsWithDeviceToken:)
    open func application(_ app: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Manager.core.logMessage(message: "Successfully registered for remote notifications with token \(deviceToken.description)", level: .info)
        
        self.addons.forEach { [weak self] addon in
            if let notifAddon = addon as? Halo.NotificationsAddon, let strongSelf = self {
                notifAddon.application(application: app, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken, core: strongSelf)
            }
        }
    }
    
    /**
     Pass through the push notifications setup. To be called within the method in the app delegate.
     
     - parameter application: Application being configured
     - parameter error:       Error thrown during the process
     */
    @objc(application:didFailToRegisterForRemoteNotificationsWithError:)
    open func application(_ app: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        logMessage(message: HaloError.failedToRegisterForRemoteNotifications(error.localizedDescription).description, level: .error)
        
        self.addons.forEach { (addon) in
            if let notifAddon = addon as? Halo.NotificationsAddon {
                notifAddon.application(application: app, didFailToRegisterForRemoteNotificationsWithError: error, core: self)
            }
        }
    }
    
    @objc(application:didReceiveRemoteNotification:)
    open func application(_ app: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        self.addons.forEach { (addon) in
            if let notifAddon = addon as? Halo.NotificationsAddon {
                notifAddon.application(application: app, didReceiveRemoteNotification: userInfo, core: self, fetchCompletionHandler: { _ in })
            }
        }
    }
    
    @objc(application:didReceiveRemoteNotification:fetchCompletionHandler:)
    open func application(_ app: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        self.addons.forEach { (addon) in
            if let notifAddon = addon as? Halo.NotificationsAddon {
                notifAddon.application(application: app, didReceiveRemoteNotification: userInfo, core: self, fetchCompletionHandler: completionHandler)
            }
        }
    }
    
    @objc(applicationWillFinishLaunching:)
    open func applicationWillFinishLaunching(_ application: UIApplication) -> Bool {
        return self.addons.reduce(true) { $0 && ($1 as? LifecycleAddon)?.applicationWillFinishLaunching(application, core: self) ?? true }
    }
    
    @objc(applicationDidFinishLaunching:launchOptions:)
    open func applicationDidFinishLaunching(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        return self.addons.reduce(true) { $0 && ($1 as? LifecycleAddon)?.applicationDidFinishLaunching(application, core: self, didFinishLaunchingWithOptions: launchOptions) ?? true }
    }
    
    @objc(applicationDidBecomeActive:)
    open func applicationDidBecomeActive(_ app: UIApplication) {
        self.addons.forEach { ($0 as? LifecycleAddon)?.applicationDidBecomeActive(app, core: self) }
    }
    
    @objc(applicationDidEnterBackground:)
    open func applicationDidEnterBackground(_ app: UIApplication) {
        self.addons.forEach { ($0 as? LifecycleAddon)?.applicationDidEnterBackground(app, core: self) }
    }
    
    @objc(application:openURL:options:)
    open func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return self.addons.reduce(false) { $0 || ($1 as? DeeplinkingAddon)?.application(app, open: url, options: options) ?? false }
    }
    
    @objc(application:openURL:sourceApplication:annotation:)
    open func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return self.addons.reduce(false) { $0 || ($1 as? DeeplinkingAddon)?.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) ?? false }
    }
    
    fileprivate func checkNeedsUpdate(completionHandler handler: ((Bool) -> Void)? = nil) -> Void {
        
        try! Request<Any>(router: .versionCheck).response { (_, result) in
            switch result {
            case .success(let data as [[String: AnyObject]], _):
                if let info = data.first, let minIOS = info["minIOS"] {
                    if minIOS.compare(self.frameworkVersion, options: .numeric) == .orderedDescending {
                        let changelog = info["iosChangeLog"] as! String
                        
                        self.logMessage(message: "The version of the Halo SDK you are using is outdated. Please update to ensure there are no breaking changes. Minimum version: \(minIOS). Version changelog: \(changelog)", level: .warning)
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
    
    public func addLogger(_ logger: Logger) {
        self.loggers.append(logger)
    }
    
    public func addLoggers(_ loggers: [Logger]) {
        self.loggers.append(contentsOf: loggers)
    }
    
    // MARK: Logger protocol
    
    public func logMessage(message: String, level: LogLevel) {
        
        if self.logLevel.rawValue >= level.rawValue {
            self.loggers.forEach { $0.logMessage(message: message, level: level) }
        }
    }
    
}

public extension Manager {
    
    public static let core: CoreManager = {
        return CoreManager()
    }()
    
}
