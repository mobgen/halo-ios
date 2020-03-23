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
open class Module: NSObject, NSCoding {

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
    open internal(set) var customerId: Int?

    /// Unique identifier of the module
    @objc open internal(set) var id: String?

    /// Visual name of the module
    @objc open internal(set) var name: String?

    /// Identifies the module as single item module
    @objc open internal(set) var isSingle: Bool = false

    /// Date in which the module was created
    @objc open internal(set) var createdAt: Date?

    /// Date of the last update performed in this module
    @objc open internal(set) var updatedAt: Date?

    /// Name of the user who created the module in the first place
    @objc open internal(set) var createdBy: String?
    
    /// Name of the user who updated the module in last place
    @objc open internal(set) var updatedBy: String?

    @objc open internal(set) var deletedAt: Date?
    
    @objc open internal(set) var deletedBy: String?
    
    /// Dictionary of tags associated to this module
    @objc open internal(set) var tags: [String: Halo.Tag] = [:]

    fileprivate override init() {
        super.init()
    }

    /**
     Initialise a HaloModule from a dictionary

     - parameter dict:   Dictionary containing the information about the module
     */
    @objc static func fromDictionary(dict: [String: AnyObject]) -> Halo.Module {

        let module = Module()

        module.id = dict[Keys.Id] as? String
        module.customerId = dict[Keys.Customer] as? Int
        module.name = dict[Keys.Name] as? String
        module.isSingle = dict[Keys.IsSingle] as? Bool ?? false
        module.createdBy = dict[Keys.CreatedBy] as? String
        module.updatedBy = dict[Keys.UpdatedBy] as? String
        module.deletedBy = dict[Keys.DeletedBy] as? String
        module.tags = [:]

        if let tagsList = dict[Keys.Tags] as? [[String: AnyObject]] {
            module.tags = tagsList.map({ (dict) -> Halo.Tag in
                return Halo.Tag.fromDictionary(dict: dict)
            }).reduce(module.tags, { (dict, tag: Halo.Tag) -> [String: Halo.Tag] in
                var varDict = dict
                varDict[tag.name] = tag
                return varDict
            })
        }

        if let created = dict[Keys.CreatedAt] as? Double {
            module.createdAt = Date(timeIntervalSince1970: created/1000)
        }

        if let updated = dict[Keys.UpdatedAt] as? Double {
            module.updatedAt = Date(timeIntervalSince1970: updated/1000)
        }
        
        if let deleted = dict[Keys.DeletedAt] as? Double {
            module.deletedAt = Date(timeIntervalSince1970: deleted/1000)
        }

        return module
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init()
        id = aDecoder.decodeObject(forKey: Keys.Id) as? String
        customerId = aDecoder.decodeObject(forKey: Keys.Customer) as? Int
        name = aDecoder.decodeObject(forKey: Keys.Name) as? String
        isSingle = aDecoder.decodeObject(forKey: Keys.IsSingle) as? Bool ?? false
        createdBy = aDecoder.decodeObject(forKey: Keys.CreatedBy) as? String
        updatedBy = aDecoder.decodeObject(forKey: Keys.UpdatedBy) as? String
        tags = aDecoder.decodeObject(forKey: Keys.Tags) as! [String: Halo.Tag]
        createdAt = aDecoder.decodeObject(forKey: Keys.CreatedAt) as? Date
        updatedAt = aDecoder.decodeObject(forKey: Keys.UpdatedAt) as? Date
        deletedAt = aDecoder.decodeObject(forKey: Keys.DeletedAt) as? Date
        deletedBy = aDecoder.decodeObject(forKey: Keys.DeletedBy) as? String
    }

    @objc open func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Keys.Id)
        aCoder.encode(customerId, forKey: Keys.Customer)
        aCoder.encode(name, forKey: Keys.Name)
        aCoder.encode(isSingle, forKey: Keys.IsSingle)
        aCoder.encode(createdBy, forKey: Keys.CreatedBy)
        aCoder.encode(updatedBy, forKey: Keys.UpdatedBy)
        aCoder.encode(tags, forKey: Keys.Tags)
        aCoder.encode(createdAt, forKey: Keys.CreatedAt)
        aCoder.encode(updatedAt, forKey: Keys.UpdatedAt)
        aCoder.encode(deletedAt, forKey: Keys.DeletedAt)
        aCoder.encode(deletedBy, forKey: Keys.DeletedBy)
    }

}
