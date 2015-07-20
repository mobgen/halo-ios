//
//  File.swift
//  HaloFramework
//
//  Created by Borja Santos-Díez on 22/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/// Generic class which holds the common features of a module within the Framework
@objc
public class HaloModule {
    
    /// Provides access to the manager containing this specific module
    public var manager:HaloManager?
    
    /**
    Initialise the module from a provided configuration
    
    :param: config   Dictionary containing all the configuration details for this module
    */
    required public init(configuration: NSDictionary? = nil) {
        if let dict = configuration as? Dictionary<String,AnyObject> {
//            if let name = dict[HaloCoreConstants.moduleNameKey] as? String {
//                
//            }
        }
    }

    /**
    Verbose description of the module intended to be used for debugging
    
    :returns: A string representation of the module, containing its class name
    */
    public func moduleDescription() -> String {
        return  "Module: \(toString(self))"
    }
    
}