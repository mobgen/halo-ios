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
    
    func setup(haloCore core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void {
        
    }
    
    func startup(haloCore core: Halo.CoreManager, completionHandler handler: ((Halo.Addon, Bool) -> Void)?) -> Void {
        
    }
    
    func willRegisterAddon(haloCore core: Halo.CoreManager) -> Void {
        
    }
    
    func didRegisterAddon(haloCore core: Halo.CoreManager) -> Void {
        
    }
    
    func willRegisterUser(haloCore core: Halo.CoreManager) -> Void {
        
    }
    
    func didRegisterUser(haloCore core: Halo.CoreManager) -> Void {
        
    }
    
    func applicationDidFinishLaunching(application app: UIApplication, core: Halo.CoreManager) -> Void {
        
    }
    
    func applicationDidEnterBackground(application app: UIApplication, core: Halo.CoreManager) -> Void {
        
    }
    
    func applicationDidBecomeActive(application app: UIApplication, core: Halo.CoreManager) -> Void {
        
    }
    
}
