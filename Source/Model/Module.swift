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
@objc(HaloModule)
public class Module: NSObject {

    /// Unique identifier of the module
    public var id: NSNumber?

    /// Visual name of the module
    public var name: String?

    /// Type of the module
    public var type: Halo.ModuleType?

    /// Identifies the module as enabled or not
    public var enabled: Bool
    
    /// Identifies the module as single item module
    public var isSingle: Bool
    
    /// Date of the last update performed in this module
    public var lastUpdate: NSDate?

    /// Internal id of the module
    public var internalId: String?
    
    /// Dictionary of tags associated to this module
    public var tags: [String: Halo.Tag]

    /**
    Initialise a HaloModule from a dictionary
    
    - parameter dict:   Dictionary containing the information about the module
    */
    init(_ dict: Dictionary<String,AnyObject>) {
        id = dict["id"] as? NSNumber
        name = dict["name"] as? String
        isSingle = dict["isSingle"] as? Bool ?? false
        enabled = dict["enabled"] as? Bool ?? false
        tags = [:]
        
        if let tagsList = dict["tags"] as? [[String: AnyObject]] {
            tags = tagsList.map({ (dict) -> Halo.Tag in
                return Halo.Tag.fromDictionary(dict)
            }).reduce([:], combine: { (var dict, tag: Halo.Tag) -> [String: Halo.Tag] in
                dict[tag.name] = tag
                return dict
            })
        }
        
        let moduleTypeDict = dict["moduleType"] as? Dictionary<String, AnyObject> ?? [String: AnyObject]()
        type = ModuleType(moduleTypeDict)

        if let updated = dict["updatedAt"] as? NSNumber {
            lastUpdate = NSDate(timeIntervalSince1970: updated.doubleValue/1000)
        }

        if let intId = dict["internalId"] as? String {
            internalId = intId
        }
    }
}
