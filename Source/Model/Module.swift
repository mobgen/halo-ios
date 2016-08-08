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
    
    public static let kCustomer = "customer"
    public static let kId = "id"
    public static let kInternalId = "internalId"
    public static let kName = "name"
    public static let kModuleType = "moduleType"
    public static let kEnabled = "enabled"
    public static let kIsSingle = "isSingle"
    public static let kCreatedAt = "createdAt"
    public static let kUpdatedAt = "updatedAt"
    public static let kUpdatedBy = "updatedBy"
    public static let kTags = "tags"
    
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
    public init(_ dict: [String: AnyObject]) {
        
        id = dict[Module.kId] as? Int
        customerId = dict[Module.kCustomer] as? Int
        internalId = dict[Module.kInternalId] as? String
        name = dict[Module.kName] as? String
        isSingle = dict[Module.kIsSingle] as? Bool ?? false
        enabled = dict[Module.kEnabled] as? Bool ?? false
        updatedBy = dict[Module.kUpdatedBy] as? String
        tags = [:]
        
        if let tagsList = dict[Module.kTags] as? [[String: AnyObject]] {
            tags = tagsList.map({ (dict) -> Halo.Tag in
                return Halo.Tag.fromDictionary(dict)
            }).reduce([:], combine: { (dict, tag: Halo.Tag) -> [String: Halo.Tag] in
                var varDict = dict
                varDict[tag.name] = tag
                return varDict
            })
        }
        
        if let moduleTypeDict = dict[Module.kModuleType] as? [String: AnyObject] {
            type = ModuleType(moduleTypeDict)
        }
        
        if let created = dict[Module.kCreatedAt] as? Double {
            createdAt = NSDate(timeIntervalSince1970: created/1000)
        }
        
        if let updated = dict[Module.kUpdatedAt] as? Double {
            updatedAt = NSDate(timeIntervalSince1970: updated/1000)
        }
    }
}
