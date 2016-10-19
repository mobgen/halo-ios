//
//  DummyAddon.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 27/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Halo
import Foundation
import UIKit

@objc
class DummyAddon: NSObject, Addon {
    
    var addonName: String = "Dummy addon"
    
    @objc(setup:completionHandler:)
    func setup(haloCore core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void {
        
    }
    
    @objc(startup:completionHandler:)
    func startup(haloCore core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void {
        
    }
    
    @objc(willRegisterAddon:)
    func willRegisterAddon(haloCore core: Halo.CoreManager) -> Void {
        
    }
    
    @objc(didRegisterAddon:)
    func didRegisterAddon(haloCore core: Halo.CoreManager) -> Void {
        
    }
    
    @objc(willRegisterDevice:)
    func willRegisterDevice(haloCore core: Halo.CoreManager) -> Void {
        
    }
    
    @objc(didRegisterDevice:)
    func didRegisterDevice(haloCore core: Halo.CoreManager) -> Void {
        
    }
    
    @objc(applicationDidFinishLaunching:core:)
    func applicationDidFinishLaunching(application app: UIApplication, core: Halo.CoreManager) -> Void {
        
    }
    
    @objc(applicationDidEnterBackground:core:)
    func applicationDidEnterBackground(application app: UIApplication, core: Halo.CoreManager) -> Void {
        
    }
    
    @objc(applicationDidBecomeActive:core:)
    func applicationDidBecomeActive(application app: UIApplication, core: Halo.CoreManager) -> Void {
        
    }
    
}
