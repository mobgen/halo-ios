//
//  HaloModuleType.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloModuleTypeCategory)
public enum ModuleTypeCategory: Int {
    case OffersModule = 3
    case PushNotifications = 2
    case GeneralContentModule = 1
}

/**
Model class representing an existing module type within Halo
*/

public struct ModuleType {

    /// Unique identifier of the module type
    public internal(set) var category: ModuleTypeCategory?

    /// Flag determining whether the module type is enabled or not
    public internal(set) var enabled: Bool = false

    /// Visual name of the module type
    public internal(set) var name: String?

    /// Url of the module type
    public internal(set) var typeUrl: String?

    /**
    Initialise the module type from a dictionary
    
    - parameter dict: Dictionary containing all the data about the module type
    */
    init(_ dict: [String: AnyObject]) {
        category = ModuleTypeCategory(rawValue: dict["id"] as! Int)
        enabled = dict["enabled"] as? Bool ?? false
        name = dict["name"] as? String
        typeUrl = dict["url"] as? String
    }

}