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
@objc public protocol HaloPushDelegate {
    /**
    This handler will be called when a push notification is received

    - parameter application:       Application receiving the push notification
    - parameter userInfo:          Dictionary containing information about the push notification
    - parameter completionHandler: Closure to be called after completion
    */
    func handlePush(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) -> Void

    /**
    This handler will be called when a push notification is received

    - parameter application:       Application receiving the silent push notification
    - parameter userInfo:          Dictionary containing information about the push notification
    - parameter completionHandler: Closure to be called after completion
    */
    func handleSilentPush(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) -> Void
}

/// Helper class intended to be used as superclass by any AppDelegate (Swift only)
public class HaloAppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Push notifications

    /**
    Just pass through the configuration of the push notifications to the manager.
    
    - parameter application: Application being configured
    - parameter deviceToken: Device token obtained in previous steps
    */
    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Halo.Manager.sharedInstance.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    /**
     Just pass through the configuration of the push notifications to the manager.
     
     - parameter application: Application being configured
     - parameter error:       Error thrown during the process
     */
    public func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        Halo.Manager.sharedInstance.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }

    /**
     Handle push notifications
     
     - parameter application:       Application receiving the push notification
     - parameter userInfo:          Dictionary containing all the information about the notification
     - parameter completionHandler: Handler to be executed once the fetch has finished
     */
    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {

        let halo = Halo.Manager.sharedInstance
        NSLog("Content: \(userInfo)")

        if let silent = userInfo["content_available"] as? Int {
            if silent == 1 {
                halo.pushDelegate?.handleSilentPush(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
            } else {
                halo.pushDelegate?.handlePush(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
            }
        } else {
            halo.pushDelegate?.handlePush(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }

    }

}
