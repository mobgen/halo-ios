//
//  HaloModuleType.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

public enum ModuleTypeCategory: Int {
    case OffersModule = 3
    case GeneralContentModule = 1
}

/// Model class representing an existing module type within Halo
public class ModuleType: NSObject {

    /// Unique identifier of the module type
    public var category: ModuleTypeCategory?

    /// Flag determining whether the module type is enabled or not
    public var enabled: Bool = false

    /// Visual name of the module type
    public var name: String?

    /// Url of the module type
    public var typeUrl: String?

    /**
    Initialise the module type from a dictionary
    
    - parameter dict: Dictionary containing all the data about the module type
    */
    init(_ dict: Dictionary<String, AnyObject>) {
        super.init()
        category = ModuleTypeCategory(rawValue: dict["id"] as! Int)
        enabled = dict["enabled"] as? Bool ?? false
        name = dict["name"] as? String
        typeUrl = dict["url"] as? String
    }

}