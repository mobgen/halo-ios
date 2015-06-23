//
//  Networking.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import HALOCore

@objc(HALONetworking)
public class HALONetworking: HALOModule {
    
    var token:String?
    var refreshToken:String?
    
    public func authenticate() -> Bool {
        println("Trying to authenticate...")
        return true
    }
    
}