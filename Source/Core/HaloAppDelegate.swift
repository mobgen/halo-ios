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

    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        var configureError:NSError?
        
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        Manager.sharedInstance.gcmSenderId = GGLContext.sharedInstance().configuration.gcmSenderID
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        
        let gcmConfig = GCMConfig.defaultConfig()
        gcmConfig.receiverDelegate = Manager.sharedInstance
        GCMService.sharedInstance().startWithConfig(gcmConfig)
        
        return true
    }
    
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

    public func applicationDidBecomeActive(application: UIApplication) {
        // Connect to the GCM server to receive non-APNS notifications
        GCMService.sharedInstance().connectWithHandler({
            (error) -> Void in
            if error != nil {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                print("Connected to GCM")
            }
        })
    }
    
    public func applicationDidEnterBackground(application: UIApplication) {
        GCMService.sharedInstance().disconnect()
    }
    
    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        self.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: { (fetchResult) -> Void in })
    }
    
    /**
     Handle push notifications
     
     - parameter application:       Application receiving the push notification
     - parameter userInfo:          Dictionary containing all the information about the notification
     - parameter completionHandler: Handler to be executed once the fetch has finished
     */
    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {

        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        
        let halo = Halo.Manager.sharedInstance
        
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
