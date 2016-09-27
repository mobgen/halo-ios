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
    
    func setup(core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void {
        
    }
    
    func startup(core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void {
        
    }
    
    func willRegisterAddon(core: Halo.CoreManager) -> Void {
        
    }
    
    func didRegisterAddon(core: Halo.CoreManager) -> Void {
        
    }
    
    func willRegisterUser(core: Halo.CoreManager) -> Void {
        
    }
    
    func didRegisterUser(core: Halo.CoreManager) -> Void {
        
    }
    
    func applicationDidFinishLaunching(application: UIApplication, core: Halo.CoreManager) -> Void {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication, core: Halo.CoreManager) -> Void {
        
    }
    
    func applicationDidBecomeActive(application: UIApplication, core: Halo.CoreManager) -> Void {
        
    }
    
}
