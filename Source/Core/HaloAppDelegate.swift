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
public protocol HaloDelegate {
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

/// Helper class intended to be used as superclass by any AppDelegate
public class HaloAppDelegate: UIResponder, UIApplicationDelegate {

    let mgr = Halo.Manager.sharedInstance

    /// Instance implementing the HaloDelegate protocol
    public var delegate: HaloDelegate?

    // MARK: Push notifications

    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        mgr.setupPushNotifications(application: application, deviceToken: deviceToken)
    }

    public func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("Couldn't register: \(error)")
        mgr.setupPushNotifications(application: application, deviceToken: "<testToken>".dataUsingEncoding(NSUTF8StringEncoding)!)
    }

    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {

        NSLog("Content: \(userInfo)")

        if let silent = userInfo["content_available"] as? Int {
            if silent == 1 {
                delegate?.handleSilentPush(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
            } else {
                delegate?.handlePush(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
            }
        } else {
            delegate?.handlePush(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }

        completionHandler(.NoData)

    }

}
