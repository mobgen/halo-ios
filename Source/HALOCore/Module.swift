//
//  File.swift
//  HaloFramework
//
//  Created by Borja Santos-Díez on 22/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(Module)
public class Module {
    
    public let moduleName:String
    
    required public init(name: String) {
        moduleName = name
    }
    
    required public init(config: NSDictionary) {
        moduleName = config["HALO_MODULE_NAME"] as! String
    }
    
    public func moduleDescription() -> String {
        return  "name: \(moduleName) class: \(toString(self))"
    }
    
}