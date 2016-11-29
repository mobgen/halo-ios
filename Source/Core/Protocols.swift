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
public protocol Addon: class {

    var addonName: String {get}

    func setup(haloCore core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void
    
    func startup(haloCore core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void

    func willRegisterAddon(haloCore core: Halo.CoreManager) -> Void
    
    func didRegisterAddon(haloCore core: Halo.CoreManager) -> Void

    func willRegisterDevice(haloCore core: Halo.CoreManager) -> Void
    
    func didRegisterDevice(haloCore core: Halo.CoreManager) -> Void

    func applicationDidFinishLaunching(_ app: UIApplication, core: Halo.CoreManager) -> Void
    
    func applicationDidEnterBackground(_ app: UIApplication, core: Halo.CoreManager) -> Void
    
    func applicationDidBecomeActive(_ app: UIApplication, core: Halo.CoreManager) -> Void

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    
}

public extension Addon {
    
    func setup(haloCore core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void {}
    
    func startup(haloCore core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void {}
    
    func willRegisterAddon(haloCore core: Halo.CoreManager) -> Void {}
    
    func didRegisterAddon(haloCore core: Halo.CoreManager) -> Void {}
    
    func willRegisterDevice(haloCore core: Halo.CoreManager) -> Void {}
    
    func didRegisterDevice(haloCore core: Halo.CoreManager) -> Void {}
    
    func applicationDidFinishLaunching(_ app: UIApplication, core: Halo.CoreManager) -> Void {}
    
    func applicationDidEnterBackground(_ app: UIApplication, core: Halo.CoreManager) -> Void {}
    
    func applicationDidBecomeActive(_ app: UIApplication, core: Halo.CoreManager) -> Void {}
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return false
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return false
    }
    
}

@objc(HaloNotificationsAddon)
public protocol NotificationsAddon: Addon {

    func application(application app: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data, core: Halo.CoreManager) -> Void
    
    func application(application app: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError, core: Halo.CoreManager) -> Void

    func application(application app: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], core: Halo.CoreManager, userInteraction user: Bool, fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Void

}

public extension NotificationsAddon {
    
    func application(application app: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data, core: Halo.CoreManager) -> Void {}
    
    func application(application app: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError, core: Halo.CoreManager) -> Void {}
    
    func application(application app: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], core: Halo.CoreManager, userInteraction user: Bool, fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Void {}
    
}

@objc(HaloNetworkAddon)
public protocol NetworkAddon: Addon {

    func willPerformRequest(request req: URLRequest) -> Void
    
    func didPerformRequest(request req: URLRequest, time: TimeInterval, response: URLResponse?) -> Void

}

public extension NetworkAddon {
    
    func willPerformRequest(request req: URLRequest) -> Void {}
    
    func didPerformRequest(request req: URLRequest, time: TimeInterval, response: URLResponse?) -> Void {}
    
}

/// Other protocols

@objc
public protocol HaloManager {

    @objc(startup:)
    func startup(completionHandler handler: ((Bool) -> Void)?) -> Void

}
