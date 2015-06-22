//
//  HaloApplication.swift
//  HaloFramework
//
//  Created by Borja Santos-Díez on 22/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import UIKit

public class HaloApplication : UIApplication {
    
    override public func sendEvent(event: UIEvent) {
        super.sendEvent(event)
        NSLog("Test")
    }
    
}