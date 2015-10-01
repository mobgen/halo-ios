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
class AppDelegate: HaloAppDelegate, HaloDelegate {

    var window: UIWindow?
    private let mgr = Halo.Manager.sharedInstance

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        // Reset badge number
        application.applicationIconBadgeNumber = 0;
        
        navigationBarAppearace.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Lab-Medium", size: 34)!]
        navigationBarAppearace.tintColor = UIColor.blackColor()
        navigationBarAppearace.barTintColor =  UIColor.mobgenLightGreen()
        navigationBarAppearace.setTitleVerticalPositionAdjustment(5, forBarMetrics: .Default)
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        
        window!.rootViewController = ContainerViewController()
        window!.makeKeyAndVisible()
        
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

    // MARK: HaloDelegate methods

    func handlePush(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Handle push notification
        application.applicationIconBadgeNumber = 0;

        if (application.applicationState == .Active) {

            if let aps = userInfo["aps"], message = aps["alert"] as? Dictionary<String, String> {
                let alert = UIAlertController(title: "Push notification", message: message["body"], preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)

                alert.addAction(okAction)

                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
        }

        completionHandler(.NewData)

    }

    func handleSilentPush(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        NSLog("Silent push!!")

        let alert = userInfo["aps"]!["alert"] as! [NSObject: AnyObject]

        if let body = alert["body"] as? String {
            if body.lowercaseString == "configuration" {
                (window?.rootViewController as! ContainerViewController).leftMenu.loadData()
            }
        }

        if let extra = userInfo["extra"] as? [NSObject:AnyObject] {
            NSNotificationCenter.defaultCenter().postNotificationName("generalcontent", object: self, userInfo: extra)
        }
        
        completionHandler(.NewData)
    }
    
    
}
