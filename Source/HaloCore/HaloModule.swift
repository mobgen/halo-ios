//
//  HaloModule.swift
//  HaloSDK
//
//  Created by Borja on 28/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

public class HaloModule : NSObject {
    
    public let id:NSNumber
    public let name:String
    
    init(dict: Dictionary<String,AnyObject>) {
        id = dict["id"] as! NSNumber
        name = dict["name"] as! String
    }
    
    
}