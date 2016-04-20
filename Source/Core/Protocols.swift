//
//  Protocols.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 20/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

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
    func managerWillSetupUser(user: Halo.User) -> Void
    
}

/// Delegate to be implemented to handle push notifications easily
@objc(HaloPushDelegate)
public protocol PushDelegate {
    /**
     This handler will be called when any push notification is received (silent or not)
     
     - parameter application:       Application receiving the push notification
     - parameter userInfo:          Dictionary containing information about the push notification
     - parameter completionHandler: Closure to be called after completion
     */
    func haloApplication(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)?) -> Void
    
    /**
     This handler will be called when a silent push notification is received
     
     - parameter application:       Application receiving the silent push notification
     - parameter userInfo:          Dictionary containing information about the push notification
     - parameter completionHandler: Closure to be called after completion
     */
    func haloApplication(application: UIApplication, didReceiveSilentNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)?) -> Void
    
    /**
     This handler will be called when a push notification is received
     
     - parameter application:       Application receiving the silent push notification
     - parameter userInfo:          Dictionary containing information about the push notification
     - parameter completionHandler: Closure to be called after completion
     */
    func haloApplication(application: UIApplication, didReceiveNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)?) -> Void
}

/// Internal protocols

protocol HaloManager {
    
    func startup(completionHandler handler: ((Bool) -> Void)?) -> Void
    
}

protocol ModulesProvider {
    
    func getModules(offlinePolicy: OfflinePolicy?) -> Halo.Request
    
}

protocol ContentProvider {
    
    func getInstances(searchOptions: Halo.SearchOptions) -> Halo.Request
    
    func syncModule(moduleId: String, completionHandler handler: (() -> Void)?) -> Void
    
}