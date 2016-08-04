//
//  HaloModule.swift
//  HaloSDK
//
//  Created by Borja on 28/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/**
Model class representing the different modules available in Halo
*/

public struct Module {
    
    /// Identifier of the customer
    public internal(set) var customerId: Int?
    
    /// Unique identifier of the module
    public internal(set) var id: Int?

    /// Internal id of the module
    public internal(set) var internalId: String?
    
    /// Visual name of the module
    public internal(set) var name: String?

    /// Type of the module
    public internal(set) var type: Halo.ModuleType?

    /// Identifies the module as enabled or not
    public internal(set) var enabled: Bool = true
    
    /// Identifies the module as single item module
    public internal(set) var isSingle: Bool = false
    
    /// Date in which the module was created
    public internal(set) var createdAt: NSDate?
    
    /// Date of the last update performed in this module
    public internal(set) var updatedAt: NSDate?

    /// Name of the user who updated the module in last place
    public internal(set) var updatedBy: String?
    
    /// Dictionary of tags associated to this module
    public internal(set) var tags: [String: Halo.Tag] = [:]
    
    /**
    Initialise a HaloModule from a dictionary
    
    - parameter dict:   Dictionary containing the information about the module
    */
    public init(_ dict: [String:AnyObject]) {
        id = dict["id"] as? Int
        customerId = dict["customer"] as? Int
        internalId = dict["internalId"] as? String
        name = dict["name"] as? String
        isSingle = dict["isSingle"] as? Bool ?? false
        enabled = dict["enabled"] as? Bool ?? false
        updatedBy = dict["updatedBy"] as? String
        tags = [:]
        
        if let tagsList = dict["tags"] as? [[String: AnyObject]] {
            tags = tagsList.map({ (dict) -> Halo.Tag in
                return Halo.Tag.fromDictionary(dict)
            }).reduce([:], combine: { (dict, tag: Halo.Tag) -> [String: Halo.Tag] in
                var varDict = dict
                varDict[tag.name] = tag
                return varDict
            })
        }
        
        if let moduleTypeDict = dict["moduleType"] as? [String: AnyObject] {
            type = ModuleType(moduleTypeDict)
        }

        if let created = dict["createdAt"] as? Double {
            createdAt = NSDate(timeIntervalSince1970: created/1000)
        }
        
        if let updated = dict["updatedAt"] as? Double {
            updatedAt = NSDate(timeIntervalSince1970: updated/1000)
        }
    }
}
