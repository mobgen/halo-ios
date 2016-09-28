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
public class Module: NSObject, NSCoding {

    struct Keys {
        static let Customer = "customerId"
        static let Id = "id"
        static let Name = "name"
        static let ModuleType = "moduleType"
        static let IsSingle = "isSingle"
        static let CreatedBy = "createdBy"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let UpdatedBy = "updatedBy"
        static let DeletedAt = "deletedAt"
        static let DeletedBy = "deletedBy"
        static let Tags = "tags"
    }

    /// Identifier of the customer
    public internal(set) var customerId: Int?

    /// Unique identifier of the module
    public internal(set) var id: String?

    /// Visual name of the module
    public internal(set) var name: String?

    /// Identifies the module as single item module
    public internal(set) var isSingle: Bool = false

    /// Date in which the module was created
    public internal(set) var createdAt: NSDate?

    /// Date of the last update performed in this module
    public internal(set) var updatedAt: NSDate?

    /// Name of the user who created the module in the first place
    public internal(set) var createdBy: String?
    
    /// Name of the user who updated the module in last place
    public internal(set) var updatedBy: String?

    public internal(set) var deletedAt: NSDate?
    
    public internal(set) var deletedBy: String?
    
    /// Dictionary of tags associated to this module
    public internal(set) var tags: [String: Halo.Tag] = [:]

    private override init() {
        super.init()
    }

    /**
     Initialise a HaloModule from a dictionary

     - parameter dict:   Dictionary containing the information about the module
     */
    public static func fromDictionary(dict dict: [String: AnyObject]) -> Halo.Module {

        let module = Module()

        module.id = dict[Keys.Id] as? String
        module.customerId = dict[Keys.Customer] as? Int
        module.name = dict[Keys.Name] as? String
        module.isSingle = dict[Keys.IsSingle] as? Bool ?? false
        module.createdBy = dict[Keys.CreatedBy] as? String
        module.updatedBy = dict[Keys.UpdatedBy] as? String
        module.deletedAt = dict[Keys.DeletedAt] as? NSDate
        module.deletedBy = dict[Keys.DeletedBy] as? String
        module.tags = [:]

        if let tagsList = dict[Keys.Tags] as? [[String: AnyObject]] {
            module.tags = tagsList.map({ (dict) -> Halo.Tag in
                return Halo.Tag.fromDictionary(dict: dict)
            }).reduce(module.tags, combine: { (dict, tag: Halo.Tag) -> [String: Halo.Tag] in
                var varDict = dict
                varDict[tag.name] = tag
                return varDict
            })
        }

        if let created = dict[Keys.CreatedAt] as? Double {
            module.createdAt = NSDate(timeIntervalSince1970: created/1000)
        }

        if let updated = dict[Keys.UpdatedAt] as? Double {
            module.updatedAt = NSDate(timeIntervalSince1970: updated/1000)
        }

        return module
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        id = aDecoder.decodeObjectForKey(Keys.Id) as? String
        customerId = aDecoder.decodeObjectForKey(Keys.Customer) as? Int
        name = aDecoder.decodeObjectForKey(Keys.Name) as? String
        isSingle = aDecoder.decodeObjectForKey(Keys.IsSingle) as? Bool ?? false
        createdBy = aDecoder.decodeObjectForKey(Keys.CreatedBy) as? String
        updatedBy = aDecoder.decodeObjectForKey(Keys.UpdatedBy) as? String
        tags = aDecoder.decodeObjectForKey(Keys.Tags) as? [String: Halo.Tag] ?? [:]
        createdAt = aDecoder.decodeObjectForKey(Keys.CreatedAt) as? NSDate
        updatedAt = aDecoder.decodeObjectForKey(Keys.UpdatedAt) as? NSDate
        deletedAt = aDecoder.decodeObjectForKey(Keys.DeletedAt) as? NSDate
        deletedBy = aDecoder.decodeObjectForKey(Keys.DeletedBy) as? String
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: Keys.Id)
        aCoder.encodeObject(customerId, forKey: Keys.Customer)
        aCoder.encodeObject(name, forKey: Keys.Name)
        aCoder.encodeObject(isSingle, forKey: Keys.IsSingle)
        aCoder.encodeObject(createdBy, forKey: Keys.CreatedBy)
        aCoder.encodeObject(updatedBy, forKey: Keys.UpdatedBy)
        aCoder.encodeObject(tags, forKey: Keys.Tags)
        aCoder.encodeObject(createdAt, forKey: Keys.CreatedAt)
        aCoder.encodeObject(updatedAt, forKey: Keys.UpdatedAt)
        aCoder.encodeObject(deletedAt, forKey: Keys.DeletedAt)
        aCoder.encodeObject(deletedBy, forKey: Keys.DeletedBy)
    }

}
