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
    func managerWillSetupUser(user: Halo.User) -> Void

}

@objc(HaloAddon)
public protocol Addon {

    var addonName: String {get}

    func setup(core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void
    func startup(core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void

    func willRegisterAddon(core: Halo.CoreManager) -> Void
    func didRegisterAddon(core: Halo.CoreManager) -> Void

    func willRegisterUser(core: Halo.CoreManager) -> Void
    func didRegisterUser(core: Halo.CoreManager) -> Void

    func applicationDidFinishLaunching(application: UIApplication, core: Halo.CoreManager) -> Void
    func applicationDidEnterBackground(application: UIApplication, core: Halo.CoreManager) -> Void
    func applicationDidBecomeActive(application: UIApplication, core: Halo.CoreManager) -> Void

}

@objc(HaloNotificationsAddon)
public protocol NotificationsAddon: Addon {

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData, core: Halo.CoreManager) -> Void
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError, core: Halo.CoreManager) -> Void

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], core: Halo.CoreManager, fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) -> Void
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification, core: Halo.CoreManager) -> Void

}

@objc(HaloNetworkAddon)
public protocol NetworkAddon: Addon {

    func willPerformRequest(request: NSURLRequest) -> Void
    func didPerformRequest(request: NSURLRequest, time: NSTimeInterval, response: NSURLResponse?) -> Void

}

/// Other protocols

public protocol HaloManager {

    func startup(completionHandler handler: ((Bool) -> Void)?) -> Void

}

public protocol ModulesProvider {

    func getModules(offlinePolicy: OfflinePolicy?) -> Halo.Request<PaginatedModules>

}

public protocol ContentProvider {

    func getInstances(searchOptions: Halo.SearchOptions) -> Halo.Request<PaginatedContentInstances>

}
