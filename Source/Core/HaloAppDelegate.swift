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
open class HaloAppDelegate: UIResponder, UIApplicationDelegate {

    /**
    Just pass through the configuration of the push notifications to the manager.

    - parameter application: Application being configured
    - parameter deviceToken: Device token obtained in previous steps
    */
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Manager.core.application(application: application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    /**
     Just pass through the configuration of the push notifications to the manager.

     - parameter application: Application being configured
     - parameter error:       Error thrown during the process
     */
    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Manager.core.application(application: application, didFailToRegisterForRemoteNotificationsWithError: error as NSError)
    }

    open func applicationDidBecomeActive(_ application: UIApplication) {
        Manager.core.applicationDidBecomeActive(application: application)
    }

    open func applicationDidEnterBackground(_ application: UIApplication) {
        Manager.core.applicationDidEnterBackground(application: application)
    }

    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Triggered when there is user interaction
        Manager.core.application(application: application, didReceiveRemoteNotification: userInfo as [NSObject : AnyObject], userInteraction: true)
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Manager.core.application(app, open: url, options: options)
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return Manager.core.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    /**
     Handle push notifications

     - parameter application:       Application receiving the push notification
     - parameter userInfo:          Dictionary containing all the information about the notification
     - parameter completionHandler: Handler to be executed once the fetch has finished
     */
    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Manager.core.application(application: application, didReceiveRemoteNotification: userInfo as [NSObject : AnyObject], userInteraction: application.applicationState == .inactive, fetchCompletionHandler: completionHandler)
    }

}
