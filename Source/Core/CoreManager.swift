//
//  CoreManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 29/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

public class CoreManager: HaloManager {
    
    /// Delegate that will handle launching completion and other important steps in the flow
    public var delegate: ManagerDelegate?
    
    public var pushDelegate: PushDelegate?
    
    public var debug: Bool {
        get {
            return Manager.network.debug
        }
        set {
            Manager.network.debug = newValue
        }
    }
    
    public private(set) var environment: HaloEnvironment = .Prod {
        didSet {
            Router.baseURL = environment.baseUrl
            Router.token = nil
        }
    }
    
    public var defaultOfflinePolicy: OfflinePolicy = .None
    
    public var numberOfRetries: Int {
        get {
            return Manager.network.numberOfRetries
        }
        set {
            Manager.network.numberOfRetries = newValue
        }
    }

    public var authenticationMode: AuthenticationMode {
        get {
            return Manager.network.authenticationMode
        }
        set {
            Manager.network.authenticationMode = newValue
        }
    }

    public var credentials: Credentials? {
        get {
            return Manager.network.credentials
        }
    }

    public var appCredentials: Credentials? {
        get {
            return Manager.network.appCredentials
        }
        set {
            Manager.network.appCredentials = newValue
        }
    }

    public var userCredentials: Credentials? {
        get {
            return Manager.network.userCredentials
        }
        set {
            Manager.network.userCredentials = newValue
        }
    }
    
    public var frameworkVersion: String {
        return NSBundle(identifier: "com.mobgen.HaloSDK")!.objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }
    
    /// Variable to decide whether to enable push notifications or not
    public var enablePush: Bool = false
    
    /// Variable to decide whether to enable system tags or not
    public var enableSystemTags: Bool = false
    
    /// Instance holding all the user-related information
    public var user: User?

    private let gcmManager = GCMManager.sharedInstance
    
    var deviceToken: NSString? {
        get {
            return self.gcmManager.deviceToken
        }
    }
    
    private var completionHandler: ((Bool) -> Void)?
    
    init() {}

    public func setEnvironment(environment: HaloEnvironment, completionHandler handler:((Bool) -> Void)? = nil) {
        self.environment = environment
        self.completionHandler = handler
        self.configureUser()
    }

    public func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {
        
        self.completionHandler = handler
        Router.token = nil
        
        Manager.persistence.startup()
        
        Manager.network.startup { (success) -> Void in
            
            if (!success) {
                handler?(false)
                return
            }
            
            let bundle = NSBundle.mainBundle()
            
            if let path = bundle.pathForResource("Halo", ofType: "plist") {
                
                if let data = NSDictionary(contentsOfFile: path) {
                    let clientIdKey = CoreConstants.clientIdKey
                    let clientSecretKey = CoreConstants.clientSecretKey
                    let usernameKey = CoreConstants.usernameKey
                    let passwordKey = CoreConstants.passwordKey
                    let environmentKey = CoreConstants.environmentSettingKey
                    
                    if let clientId = data[clientIdKey] as? String, clientSecret = data[clientSecretKey] as? String {
                        self.appCredentials = Credentials(clientId: clientId, clientSecret: clientSecret)
                    }

                    if let username = data[usernameKey] as? String, password = data[passwordKey] as? String {
                        self.userCredentials = Credentials(username: username, password: password)
                    }
                    
                    if let env = data[environmentKey] as? String {
                        switch env.lowercaseString {
                        case "int": self.environment = .Int
                        case "qa": self.environment = .QA
                        case "prod": self.environment = .Prod
                        case "stage": self.environment = .Stage
                        default: self.environment = .Custom(env)
                        }
                    }
                    
                    self.enablePush = (data[CoreConstants.enablePush] as? Bool) ?? false
                    self.enableSystemTags = (data[CoreConstants.enableSystemTags] as? Bool) ?? false
                }
            } else {
                NSLog("No .plist found")
            }
            
            if let cred = self.credentials {
                NSLog("Using credentials: \(cred.username) / \(cred.password)")
            }
            
            self.needsUpdate { (needs) -> Void in
                
            }

            self.configureUser()

        }
        
    }

    private func configureUser() {
        self.user = Halo.User.loadUser(self.environment)

        if let user = self.user, _ = user.id {
            // Update the user
            Manager.network.getUser(user) { (result) -> Void in
                switch result {
                case .Success(let user, _):
                    self.user = user

                    if self.enablePush {
                        self.configurePush()
                    } else if self.enableSystemTags {
                        self.setupDefaultSystemTags()
                    } else {
                        self.setupUser()
                    }
                case .Failure(let error):
                    NSLog("Error: \(error.localizedDescription)")
                    if self.enableSystemTags {
                        self.setupDefaultSystemTags()
                    } else {
                        self.setupUser()
                    }
                }
            }

        } else {
            self.user = Halo.User()
            self.delegate?.managerWillSetupUser(self.user!)

            if self.enablePush {
                self.configurePush()
            } else if self.enableSystemTags {
                self.setupDefaultSystemTags()
            } else {
                self.setupUser()
            }
        }
    }

    private func configurePush() {
        self.gcmManager.configure()

        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        let gcmConfig = GCMConfig.defaultConfig()
        GCMService.sharedInstance().startWithConfig(gcmConfig)
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    private func setupDefaultSystemTags() {
        
        if let user = self.user {
            
            user.addSystemTag(CoreConstants.tagPlatformNameKey, value: "ios")
            
            let version = NSProcessInfo.processInfo().operatingSystemVersion
            var versionString = "\(version.majorVersion).\(version.minorVersion)"
            
            if (version.patchVersion > 0) {
                versionString = versionString.stringByAppendingString(".\(version.patchVersion)")
            }
            
            user.addSystemTag(CoreConstants.tagPlatformVersionKey, value: versionString)
            
            if let appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") {
                user.addSystemTag(CoreConstants.tagApplicationNameKey, value: appName.description)
            }
            
            if let appVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") {
                user.addSystemTag(CoreConstants.tagApplicationVersionKey, value: appVersion.description)
            }
            
            user.addSystemTag(CoreConstants.tagDeviceManufacturerKey, value: "Apple")
            user.addSystemTag(CoreConstants.tagDeviceModelKey, value: UIDevice.currentDevice().modelName)
            user.addSystemTag(CoreConstants.tagDeviceTypeKey, value: UIDevice.currentDevice().deviceType)
            
            user.addSystemTag(CoreConstants.tagBLESupportKey, value: nil)

            //user.addTag(CoreConstants.tagNFCSupportKey, value: "false")
            
            let screen = UIScreen.mainScreen()
            let bounds = screen.bounds
            let (width, height) = (CGRectGetWidth(bounds) * screen.scale, round(CGRectGetHeight(bounds) * screen.scale))
            
            user.addSystemTag(CoreConstants.tagDeviceScreenSizeKey, value: "\(Int(width))x\(Int(height))")
            
            switch self.environment {
            case .Int, .Stage, .QA:
                user.addSystemTag(CoreConstants.tagTestDeviceKey, value: nil)
            default:
                break
            }
                        
            self.setupUser()
        }
    }

    private func setupUser() -> Void {
        
        if let user = self.user {
            NSLog(user.description)
            self.user?.storeUser(self.environment)
            
            Manager.network.createUpdateUser(user, completionHandler: { (result) -> Void in
                
                var success = false
                
                switch result {
                case .Success(let user, _):
                    self.user = user
                    NSLog((self.user?.description)!)
                    self.user?.storeUser(self.environment)
                    success = true
                case .Failure(let error):
                    NSLog("Error: \(error.localizedDescription)")
                }
                
                self.completionHandler?(success)
            })
        } else {
            self.completionHandler?(false)
        }
    }
    
    public func saveUser(completionHandler handler: ((Halo.Result<Halo.User, NSError>) -> Void)? = nil) -> Void {
        if let user = self.user {
            Manager.network.createUpdateUser(user, completionHandler: handler)
        }
    }
    
    /**
     Set up the desired push notifications to be received. To be called after the device has been
     registered
     
     - parameter application: Current application being configured to receive push notifications
     - parameter deviceToken: Device token returned after registering for push notifications
     */
    private func setupPushNotifications(application app: UIApplication, deviceToken: NSData) {
        self.gcmManager.setupPushNotifications(deviceToken) { () -> Void in
            if self.enableSystemTags {
                self.setupDefaultSystemTags()
            } else {
                self.setupUser()
            }
        }
    }

    /**
     Pass through the push notifications setup. To be called within the method in the app delegate.

     - parameter application: Application being configured
     - parameter deviceToken: Token obtained for the current device
     */
    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        NSLog("Successfully registered for remote notifications")
        self.setupPushNotifications(application: application, deviceToken: deviceToken)
    }

    /**
     Pass through the push notifications setup. To be called within the method in the app delegate.

     - parameter application: Application being configured
     - parameter error:       Error thrown during the process
     */
    public func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("Failed registering for remote notifications: \(error.localizedDescription)")
        if self.enableSystemTags {
            self.setupDefaultSystemTags()
        } else {
            self.setupUser()
        }
    }

    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        self.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: { (fetchResult) -> Void in })
    }
    
    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        
        self.pushDelegate?.haloApplication(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        
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
    
    /**
     Extra setup steps to be called from the corresponding method in the app delegate
     
     - parameter application: Application being configured
     */
    public func applicationDidBecomeActive(application: UIApplication) {
        // Connect to the GCM server to receive non-APNS notifications
        if self.enablePush {
            GCMService.sharedInstance().connectWithHandler({
                (error) -> Void in
                if error != nil {
                    print("Could not connect to GCM: \(error.localizedDescription)")
                } else {
                    print("Connected to GCM")
                }
            })
        }
    }
    
    /**
     Extra setup steps to be called from the corresponding method in the app delegate
     
     - parameter application: Application being configured
     */
    public func applicationDidEnterBackground(application: UIApplication) {
        if self.enablePush {
            GCMService.sharedInstance().disconnect()
        }
    }
    
    private func needsUpdate(completionHandler handler: (Bool) -> Void) -> Void {
        
        Request(path: "/api/authentication/version").params(["current": "true"]).response { result in
            switch result {
            case .Success(let data as [[String: AnyObject]], _):
                if let info = data.first, minIOS = info["minIOS"] {
                    if minIOS.compare(self.frameworkVersion, options: .NumericSearch) == .OrderedDescending {
                        let changelog = info["iosChangeLog"] as! String
                        NSLog("\n-------------------\nThe version of the Halo SDK you are using is outdated. Please update to ensure there are no breaking changes. Minimum version: \(minIOS). Version changelog: \(changelog)\n-------------------")
                    }
                }
            case .Failure(_):
                handler(false)
            default:
                break
            }
        }
        
    }
    
}