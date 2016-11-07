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
    @objc(managerWillSetupDevice:)
    func managerWillSetupDevice(_ device: Halo.Device) -> Void

}

@objc(HaloAddon)
public protocol Addon {

    var addonName: String {get}

    @objc(setup:completionHandler:)
    func setup(haloCore core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void
    
    @objc(startup:completionHandler:)
    func startup(haloCore core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void

    @objc(willRegisterAddon:)
    func willRegisterAddon(haloCore core: Halo.CoreManager) -> Void
    
    @objc(didRegisterAddon:)
    func didRegisterAddon(haloCore core: Halo.CoreManager) -> Void

    @objc(willRegisterDevice:)
    func willRegisterDevice(haloCore core: Halo.CoreManager) -> Void
    
    @objc(didRegisterDevice:)
    func didRegisterDevice(haloCore core: Halo.CoreManager) -> Void

    @objc(applicationDidFinishLaunching:core:)
    func applicationDidFinishLaunching(application app: UIApplication, core: Halo.CoreManager) -> Void
    
    @objc(applicationDidEnterBackground:core:)
    func applicationDidEnterBackground(application app: UIApplication, core: Halo.CoreManager) -> Void
    
    @objc(applicationDidBecomeActive:core:)
    func applicationDidBecomeActive(application app: UIApplication, core: Halo.CoreManager) -> Void

}

@objc(HaloNotificationsAddon)
public protocol NotificationsAddon: Addon {

    @objc(application:didRegisterForRemoteNotificationsWithDeviceToken:core:)
    func application(application app: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data, core: Halo.CoreManager) -> Void
    
    @objc(application:didFailToRegisterForRemoteNotificationsWithError:core:)
    func application(application app: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError, core: Halo.CoreManager) -> Void

    @objc(application:didReceiveRemoteNotification:core:userInteraction:fetchCompletionHandler:)
    func application(application app: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], core: Halo.CoreManager, userInteraction user: Bool, fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Void

}

@objc(HaloNetworkAddon)
public protocol NetworkAddon: Addon {

    @objc(willPerformRequest:)
    func willPerformRequest(request req: URLRequest) -> Void
    
    @objc(didPerformRequest:time:response:)
    func didPerformRequest(request req: URLRequest, time: TimeInterval, response: URLResponse?) -> Void

}

/// Other protocols

@objc
public protocol HaloManager {

    @objc(startup:)
    func startup(completionHandler handler: ((Bool) -> Void)?) -> Void

}
