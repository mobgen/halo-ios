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
class DummyAddon: NSObject, HaloAddon {
    
    var addonName: String = "Dummy addon"
    
    @objc(setup:completionHandler:)
    func setup(haloCore core: Halo.CoreManager, completionHandler handler: ((HaloAddon, Bool) -> Void)?) -> Void {
        
    }
    
    @objc(startup:core:completionHandler:)
    func startup(app: UIApplication, haloCore core: Halo.CoreManager, completionHandler handler: ((HaloAddon, Bool) -> Void)?) -> Void {
        
    }
    
    @objc(willRegisterAddon:)
    func willRegisterAddon(haloCore core: Halo.CoreManager) -> Void {
        
    }
    
    @objc(didRegisterAddon:)
    func didRegisterAddon(haloCore core: Halo.CoreManager) -> Void {
        
    }
    
}
