//
//  File.swift
//  HaloFramework
//
//  Created by Borja Santos-Díez on 22/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation


/// Generic class which holds the common features of a module within the Framework
@objc(HaloModule)
public class HaloModule {
    
    let moduleType:HaloModuleType?
    
    /// Provides access to the manager containing this specific module
    public var manager:HaloManager?
    
    /**
    Initialise the module only providing a name. Any extra configuration should be
    done manually afterwards
    
    :param: name   String representing the module's name
    */
    required public init(type: HaloModuleType) {
        moduleType = type
    }
    
    /**
    Initialise the module from a provided configuration
    
    :param: config   Dictionary containing all the configuration details for this module
    */
    required public init(config: NSDictionary?) {
        if let dict = config as? Dictionary<String,AnyObject> {
            if let name = dict[HaloCoreConstants.moduleNameKey] as? String {
                moduleType = HaloModuleType.fromRaw(name.lowercaseString)
                return
            }
        }
        moduleType = nil
    }

    /**
    Verbose description of the module intended to be used for debugging
    
    :returns: A string representation of the module, containing its class name
    */
    public func moduleDescription() -> String {
        return  "Module: \(toString(self))"
    }
    
}