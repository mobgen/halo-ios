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

import Foundation
import UIKit

@objc(HaloManagerDelegate)
public protocol ManagerDelegate {

    /**
     This delegate method provides full freedom to create the user that will be registered by the application.

     - returns: The newly created user
     */
    func managerWillSetupDevice(device: Halo.Device) -> Void

}

@objc(HaloAddon)
public protocol Addon {

    var addonName: String {get}

    func setup(haloCore core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void
    func startup(haloCore core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void

    func willRegisterAddon(haloCore core: Halo.CoreManager) -> Void
    func didRegisterAddon(haloCore core: Halo.CoreManager) -> Void

    func willRegisterDevice(haloCore core: Halo.CoreManager) -> Void
    func didRegisterDevice(haloCore core: Halo.CoreManager) -> Void

    func applicationDidFinishLaunching(application app: UIApplication, core: Halo.CoreManager) -> Void
    func applicationDidEnterBackground(application app: UIApplication, core: Halo.CoreManager) -> Void
    func applicationDidBecomeActive(application app: UIApplication, core: Halo.CoreManager) -> Void

}

@objc(HaloNotificationsAddon)
public protocol NotificationsAddon: Addon {

    func application(application app: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData, core: Halo.CoreManager) -> Void
    func application(application app: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError, core: Halo.CoreManager) -> Void

    func application(application app: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], core: Halo.CoreManager, fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) -> Void

}

@objc(HaloNetworkAddon)
public protocol NetworkAddon: Addon {

    func willPerformRequest(request req: NSURLRequest) -> Void
    func didPerformRequest(request req: NSURLRequest, time: NSTimeInterval, response: NSURLResponse?) -> Void

}

/// Other protocols

@objc
public protocol HaloManager {

    func startup(completionHandler handler: ((Bool) -> Void)?) -> Void

}
