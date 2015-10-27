//
//  HaloAppDelegate.swift
//  HaloSDK
//
//  Created by Borja on 01/10/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit

/// Delegate to be implemented to handle several events coming from the Halo SDK
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

    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Halo.Manager.sharedInstance.setupPushNotifications(application: application, deviceToken: deviceToken)
    }

    public func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("Couldn't register: \(error)")
        Halo.Manager.sharedInstance.setupDefaultSystemTags()
    }

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
