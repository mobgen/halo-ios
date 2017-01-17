//
//  GeneralContentInstance.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 05/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/**
This model class represents each of the instances stored as general content data.
*/

@objc(HaloContentInstance)
open class ContentInstance: NSObject, NSCoding {

    struct Keys {
        static let Id = "id"
        static let Name = "name"
        static let Module = "module"
        static let Values = "values"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let DeletedAt = "deletedAt"
        static let CreatedBy = "createdBy"
        static let UpdatedBy = "updatedBy"
        static let DeletedBy = "deletedBy"
        static let RemovedAt = "removedAt"
        static let ArchivedAt = "archivedAt"
        static let PublishedAt = "publishedAt"
        static let Tags = "tags"
    }

    /// Unique identifier of this General Content instance
    open internal(set) var id: String?

    /// Id of the module to which this instance belongs
    open internal(set) var moduleId: String = ""

    /// Name of the instance
    open internal(set) var name: String = ""

    /// Collection of key-value pairs which make up the information of this instance
    open internal(set) var values: [String: Any] = [:]

    /// Date in which the content was created
    open internal(set) var createdAt: Date

    /// Most recent date in which the content was updated
    open internal(set) var updatedAt: Date?
    
    open internal(set) var deletedAt: Date?
    
    /// Date in which the content was (or is going to be) removed
    open internal(set) var removedAt: Date?
    
    /// Date in which the content was (or is going to be) published
    open internal(set) var publishedAt: Date?

    open internal(set) var archivedAt: Date?
    
    /// Name of the creator of the content
    open internal(set) var createdBy: String?

    open internal(set) var updatedBy: String?
    
    open internal(set) var deletedBy: String?
    
    
    /// Dictionary of tags associated to this general content instance
    open var tags: [String: Halo.Tag] = [:]

    fileprivate override init() {
        createdAt = Date()
        super.init()
    }

    public convenience init(name: String, moduleId: String, values: [String: Any] = [:], tags: [Halo.Tag] = []) {
        self.init()
        
        self.name = name
        self.moduleId = moduleId
        self.values = values
        
        tags.forEach { self.tags[$0.name] = $0 }
    }
    
    static func fromDictionary(dict: [String: Any]) -> ContentInstance {

        let instance = ContentInstance()

        instance.id = dict[Keys.Id] as? String
        
        instance.moduleId = dict[Keys.Module] as? String ?? ""
        instance.name = dict[Keys.Name] as? String ?? ""

        instance.createdBy = dict[Keys.CreatedBy] as? String
        instance.deletedBy = dict[Keys.DeletedBy] as? String
        instance.updatedBy = dict[Keys.UpdatedBy] as? String

        if let valuesList = dict[Keys.Values] as? [String: AnyObject] {
            instance.values = valuesList
        }

        if let tagsList = dict[Keys.Tags] as? [[String: AnyObject]] {
            instance.tags = tagsList.map { Halo.Tag.fromDictionary(dict: $0) }.reduce([:]) { (tagsDict, tag: Halo.Tag) -> [String: Halo.Tag] in
                var varDict = tagsDict
                varDict[tag.name] = tag
                return varDict
            }
        }

        if let created = dict[Keys.CreatedAt] as? Double {
            instance.createdAt = Date(timeIntervalSince1970: created/1000)
        }

        if let updated = dict[Keys.UpdatedAt] as? Double {
            instance.updatedAt = Date(timeIntervalSince1970: updated/1000)
        }

        if let published = dict[Keys.PublishedAt] as? Double {
            instance.publishedAt = Date(timeIntervalSince1970: published/1000)
        }

        if let removed = dict[Keys.RemovedAt] as? Double {
            instance.removedAt = Date(timeIntervalSince1970: removed/1000)
        }
        
        if let deleted = dict[Keys.DeletedAt] as? Double {
            instance.deletedAt = Date(timeIntervalSince1970: deleted/1000)
        }
        
        if let archived = dict[Keys.ArchivedAt] as? Double {
            instance.archivedAt = Date(timeIntervalSince1970: archived/1000)
        }

        return instance

    }

    func toDictionary() -> [String: Any] {
        
        var dict: [String: Any] = [:]
        
        if let id = self.id {
            dict[Keys.Id] = id
        }
        
        dict[Keys.Module] = self.moduleId
        dict[Keys.Name] = self.name
        dict[Keys.CreatedAt] = self.createdAt.timeIntervalSince1970 * 1000
        
        if let publishedAt = self.publishedAt {
            dict[Keys.PublishedAt] = publishedAt.timeIntervalSince1970 * 1000
        }
        
        if let updatedAt = self.updatedAt {
            dict[Keys.UpdatedAt] = updatedAt.timeIntervalSince1970 * 1000
        }
        
        if let removedAt = self.removedAt {
            dict[Keys.RemovedAt] = removedAt.timeIntervalSince1970 * 1000
        }
        
        if let deletedAt = self.deletedAt {
            dict[Keys.DeletedAt] = deletedAt.timeIntervalSince1970 * 1000
        }
        
        if let archivedAt = self.archivedAt {
            dict[Keys.ArchivedAt] = archivedAt.timeIntervalSince1970 * 1000
        }
        
        // Set values
        dict[Keys.Values] = self.values
        
        // Set tags (if any)
        dict[Keys.Tags] = self.tags.map { $1.toDictionary() }
        
        return dict
    }
    
    public required init?(coder aDecoder: NSCoder) {
        moduleId = aDecoder.decodeObject(forKey: Keys.Module) as? String ?? ""
        name = aDecoder.decodeObject(forKey: Keys.Name) as? String ?? ""
        createdAt = aDecoder.decodeObject(forKey: Keys.CreatedAt) as? Date ?? Date()
        
        super.init()
        
        id = aDecoder.decodeObject(forKey: Keys.Id) as? String
        values = aDecoder.decodeObject(forKey: Keys.Values) as! [String: AnyObject]
        createdBy = aDecoder.decodeObject(forKey: Keys.CreatedBy) as? String
        updatedBy = aDecoder.decodeObject(forKey: Keys.UpdatedBy) as? String
        deletedBy = aDecoder.decodeObject(forKey: Keys.DeletedBy) as? String
        publishedAt = aDecoder.decodeObject(forKey: Keys.PublishedAt) as? Date
        removedAt = aDecoder.decodeObject(forKey: Keys.RemovedAt) as? Date
        updatedAt = aDecoder.decodeObject(forKey: Keys.UpdatedAt) as? Date
        deletedAt = aDecoder.decodeObject(forKey: Keys.DeletedAt) as? Date
        archivedAt = aDecoder.decodeObject(forKey: Keys.ArchivedAt) as? Date
        tags = aDecoder.decodeObject(forKey: Keys.Tags) as! [String: Halo.Tag]
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Keys.Id)
        aCoder.encode(name, forKey: Keys.Name)
        aCoder.encode(moduleId, forKey: Keys.Module)
        aCoder.encode(values, forKey: Keys.Values)
        aCoder.encode(createdBy, forKey: Keys.CreatedBy)
        aCoder.encode(updatedBy, forKey: Keys.UpdatedBy)
        aCoder.encode(deletedBy, forKey: Keys.DeletedBy)
        aCoder.encode(createdAt, forKey: Keys.CreatedAt)
        aCoder.encode(publishedAt, forKey: Keys.PublishedAt)
        aCoder.encode(removedAt, forKey: Keys.RemovedAt)
        aCoder.encode(updatedAt, forKey: Keys.UpdatedAt)
        aCoder.encode(deletedAt, forKey: Keys.DeletedAt)
        aCoder.encode(archivedAt, forKey: Keys.ArchivedAt)
        aCoder.encode(tags, forKey: Keys.Tags)
    }

    /**
    Provides information about whether the general content instance is removed or not

    - returns: Boolean determining if the instance is removed
    */
    open func isRemoved() -> Bool {
        if let removed = self.removedAt {
            return removed < Date()
        }

        return false
    }

    /**
    Provides information about whether the general content instance is published or not

    - returns: Boolean determining if the instance is published
    */
    open func isPublished() -> Bool {
        if let published = self.publishedAt {
            return published < Date()
        }

        return false
    }
    
    open func isDeleted() -> Bool {
        if let deleted = self.deletedAt {
            return deleted < Date()
        }
        
        return false
    }

    open func getValue(key: String) -> Any? {
        return self.values[key]
    }

}