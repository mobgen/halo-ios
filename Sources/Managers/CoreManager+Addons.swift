//
//  CoreManager+Addons.swift
//  Halo
//
//  Created by Borja Santos-Díez on 19/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public extension CoreManager {
    
    /**
     Allows registering an add-on within the Core Manager.
     
     - parameter a: Add-on implementation
     */
    @objc(registerAddon:)
    func registerAddon(addon a: HaloAddon) -> Void {
        a.willRegisterAddon(haloCore: self)
        self.addons.append(a)
        a.didRegisterAddon(haloCore: self)
    }
    
    func getAddons<T: HaloAddon>(type: T.Type) -> [T] {
        return self.addons.filter { $0 is T } as! [T]
    }
    
    func setupAndStartAddons(_ handler: @escaping (Bool) -> Void) -> Void {
        
        setupAddons { success in
            if success {
                self.startupAddons(handler)
            } else {
                handler(success)
            }
        }
        
    }
    
    fileprivate func setupAddons(_ handler: @escaping ((Bool) -> Void)) -> Void {
        
        if self.addons.isEmpty {
            handler(true)
            return
        }
        
        var counter = 0
        var globalSuccess = true
        
        self.addons.forEach { $0.setup(haloCore: self) { (addon, success) in

            globalSuccess = globalSuccess && success

            if success {
                self.logMessage("Successfully set up the \(addon.addonName) addon", level: .info)
            } else {
                self.logMessage("There has been an error setting up the \(addon.addonName) addon", level: .info)
            }
            
            counter += 1
            
            if counter == self.addons.count {
                handler(globalSuccess)
            }
            }
        }
        
    }
    
    fileprivate func startupAddons(_ handler: @escaping ((Bool) -> Void)) -> Void {
        
        if self.addons.isEmpty {
            handler(true)
            return
        }
        
        var counter = 0
        
        guard let app = self.app else {
            handler(false)
            return
        }

        var globalSuccess = true

        self.addons.forEach { $0.startup(app: app, haloCore: self) { (addon, success) in

            globalSuccess = globalSuccess && success

            if success {
                self.logMessage("Successfully started the \(addon.addonName) addon", level: .info)
            } else {
                self.logMessage("There has been an error starting the \(addon.addonName) addon", level: .info)
            }
            
            counter += 1
            
            if counter == self.addons.count {
                handler(globalSuccess)
            }
            
            }
        }
    }
    
}
