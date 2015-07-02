//
//  File.swift
//  HaloFramework
//
//  Created by Borja Santos-Díez on 22/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation


/// Generic class which holds the common features of a module within the Framework
@objc(Module)
public class Module {
    
    let moduleName:String
    public var manager:Manager?
    
    /**
    Initialise the module only providing a name. Any extra configuration should be
    done manually afterwards
    
    :param: name   String representing the module's name
    */
    required public init(name: String) {
        moduleName = name
    }
    
    /**
    Initialise the module from a provided configuration
    
    :param: config   Dictionary containing all the configuration details for this module
    */
    required public init(config: NSDictionary) {
        moduleName = config["HALO_MODULE_NAME"] as! String
    }
    
    /**
    Verbose description of the module intended to be used for debugging
    
    :returns: A string representation of the module, containing its name and its class name
    */
    public func moduleDescription() -> String {
        return  "name: \(moduleName) class: \(toString(self))"
    }
    
}