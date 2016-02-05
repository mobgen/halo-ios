//
//  HaloAppDelegate.swift
//  HaloSDK
//
//  Created by Borja on 01/10/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit

/// Delegate to be implemented to handle push notifications easily
@objc(HaloPushDelegate)
public protocol PushDelegate {
    /**
    This handler will be called when any push notification is received (silent or not)

    - parameter application:       Application receiving the push notification
    - parameter userInfo:          Dictionary containing information about the push notification
    - parameter completionHandler: Closure to be called after completion
    */
    optional func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)?) -> Void

    /**
    This handler will be called when a silent push notification is received

    - parameter application:       Application receiving the silent push notification
    - parameter userInfo:          Dictionary containing information about the push notification
    - parameter completionHandler: Closure to be called after completion
    */
    func application(application: UIApplication, didReceiveSilentNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)?) -> Void
    
    /**
     This handler will be called when a push notification is received
     
     - parameter application:       Application receiving the silent push notification
     - parameter userInfo:          Dictionary containing information about the push notification
     - parameter completionHandler: Closure to be called after completion
     */
    func application(application: UIApplication, didReceiveNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)?) -> Void
}

/// Helper class intended to be used as superclass by any AppDelegate (Swift only)
public class HaloAppDelegate: UIResponder, UIApplicationDelegate {

    private let haloMgr = Halo.Manager.sharedInstance
    
    // MARK: Push notifications

    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        haloMgr.applicationDidFinishLaunching(application)
        return true
    }
    
    /**
    Just pass through the configuration of the push notifications to the manager.
    
    - parameter application: Application being configured
    - parameter deviceToken: Device token obtained in previous steps
    */
    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        haloMgr.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    /**
     Just pass through the configuration of the push notifications to the manager.
     
     - parameter application: Application being configured
     - parameter error:       Error thrown during the process
     */
    public func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        haloMgr.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }

    public func applicationDidBecomeActive(application: UIApplication) {
        haloMgr.applicationDidBecomeActive(application)
    }
    
    public func applicationDidEnterBackground(application: UIApplication) {
        haloMgr.applicationDidEnterBackground(application)
    }
    
    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        haloMgr.application(application, didReceiveRemoteNotification: userInfo)
    }
    
    /**
     Handle push notifications
     
     - parameter application:       Application receiving the push notification
     - parameter userInfo:          Dictionary containing all the information about the notification
     - parameter completionHandler: Handler to be executed once the fetch has finished
     */
    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        haloMgr.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
    
    public func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        haloMgr.application(application, didReceiveLocalNotification: notification)
    }
}
