//
//  HaloAppDelegate.swift
//  HaloSDK
//
//  Created by Borja on 01/10/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit

/// Helper class intended to be used as superclass by any AppDelegate (Swift only)
public class HaloAppDelegate: UIResponder, UIApplicationDelegate {

    /**
    Just pass through the configuration of the push notifications to the manager.

    - parameter application: Application being configured
    - parameter deviceToken: Device token obtained in previous steps
    */
    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Manager.core.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    /**
     Just pass through the configuration of the push notifications to the manager.

     - parameter application: Application being configured
     - parameter error:       Error thrown during the process
     */
    public func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        Manager.core.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }

    public func applicationDidBecomeActive(application: UIApplication) {
        Manager.core.applicationDidBecomeActive(application)
    }

    public func applicationDidEnterBackground(application: UIApplication) {
        Manager.core.applicationDidEnterBackground(application)
    }

    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        Manager.core.application(application, didReceiveRemoteNotification: userInfo)
    }

    /**
     Handle push notifications

     - parameter application:       Application receiving the push notification
     - parameter userInfo:          Dictionary containing all the information about the notification
     - parameter completionHandler: Handler to be executed once the fetch has finished
     */
    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        Manager.core.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }

//    public func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
//        Manager.core.application(application, didReceiveLocalNotification: notification)
//    }
}
