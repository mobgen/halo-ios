//
//  AppDelegate.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import UIKit
import Halo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let mgr = Halo.Manager.sharedInstance

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let navigationBarAppearace = UINavigationBar.appearance()

        navigationBarAppearace.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Lab-Medium", size: 34)!]
        navigationBarAppearace.tintColor = UIColor.blackColor()
        navigationBarAppearace.barTintColor = UIColor.mobgenLightGreen()

        window!.rootViewController = ContainerViewController()
        window!.makeKeyAndVisible()

        setupEnvironment()
        setupCrittercism()

        mgr.launch()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: Custom setup functions
    
    private func setupCrittercism() {
        Crittercism.enableWithAppID(Config.crittercismAppId)
    }

    private func setupEnvironment() {
        #if MG_FEED_QA
        print("Using QA configuration")
        mgr.environment = .QA
        #elseif MG_FEED_INT
        print("Using INT configuration")
        mgr.environment = .Int
        #else
        print("Using Prod configuration")
        mgr.environment = .Prod
        #endif
    }

    // MARK: Push notifications
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        mgr.setupPushNotifications(application: application, deviceToken: deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Couldn't register: \(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Handle notification
    }
    
}
