//
//  File.swift
//  HaloFramework
//
//  Created by Borja Santos-Díez on 22/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/// Generic class which holds the common features of a module within the Framework
class HaloModule : NSObject {
    
    /// Provides access to the manager containing this specific module
    var manager:Manager?
    
    /**
    Initialise the module from a provided configuration
    
    :param: config   Dictionary containing all the configuration details for this module
    */
    required init(configuration: NSDictionary? = nil) {
        if let _ = configuration as? Dictionary<String,AnyObject> {
//            if let name = dict[HaloCoreConstants.moduleNameKey] as? String {
//                
//            }
        }
    }

    /**
    Verbose description of the module intended to be used for debugging
    
    :returns: A string representation of the module, containing its class name
    */
    func moduleDescription() -> String {
        return  "Module: \(String(self))"
    }
    
}