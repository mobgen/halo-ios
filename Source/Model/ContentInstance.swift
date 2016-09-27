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
public class ContentInstance: NSObject, NSCoding {

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
    public internal(set) var id: String?

    /// Id of the module to which this instance belongs
    public internal(set) var moduleId: String?

    /// Name of the instance
    public internal(set) var name: String?

    /// Collection of key-value pairs which make up the information of this instance
    public internal(set) var values: [String: AnyObject] = [:]

    /// Date in which the content was created
    public internal(set) var createdAt: NSDate?

    /// Most recent date in which the content was updated
    public internal(set) var updatedAt: NSDate?
    
    public internal(set) var deletedAt: NSDate?
    
    /// Date in which the content was (or is going to be) removed
    public internal(set) var removedAt: NSDate?
    
    /// Date in which the content was (or is going to be) published
    public internal(set) var publishedAt: NSDate?

    public internal(set) var archivedAt: NSDate?
    
    /// Name of the creator of the content
    public var createdBy: String?

    public var updatedBy: String?
    
    public var deletedBy: String?
    
    
    /// Dictionary of tags associated to this general content instance
    public var tags: [String: Halo.Tag] = [:]

    private override init() {
        super.init()
    }

    public static func fromDictionary(dict: [String: AnyObject]) -> ContentInstance {

        let instance = ContentInstance()

        instance.id = dict[Keys.Id] as? String
        instance.moduleId = dict[Keys.Module] as? String
        instance.name = dict[Keys.Name] as? String

        instance.createdBy = dict[Keys.CreatedBy] as? String
        instance.deletedBy = dict[Keys.DeletedBy] as? String
        instance.updatedBy = dict[Keys.UpdatedBy] as? String

        if let valuesList = dict[Keys.Values] as? [String: AnyObject] {
            instance.values = valuesList
        }

        if let tagsList = dict[Keys.Tags] as? [[String: AnyObject]] {
            instance.tags = tagsList.map { Halo.Tag.fromDictionary($0) }.reduce([:]) { (tagsDict, tag: Halo.Tag) -> [String: Halo.Tag] in
                var varDict = tagsDict
                varDict[tag.name] = tag
                return varDict
            }
        }

        if let created = dict[Keys.CreatedAt] as? Double {
            instance.createdAt = NSDate(timeIntervalSince1970: created/1000)
        }

        if let updated = dict[Keys.UpdatedAt] as? Double {
            instance.updatedAt = NSDate(timeIntervalSince1970: updated/1000)
        }

        if let published = dict[Keys.PublishedAt] as? Double {
            instance.publishedAt = NSDate(timeIntervalSince1970: published/1000)
        }

        if let removed = dict[Keys.RemovedAt] as? Double {
            instance.removedAt = NSDate(timeIntervalSince1970: removed/1000)
        }
        
        if let deleted = dict[Keys.DeletedAt] as? Double {
            instance.deletedAt = NSDate(timeIntervalSince1970: deleted/1000)
        }
        
        if let archived = dict[Keys.ArchivedAt] as? Double {
            instance.archivedAt = NSDate(timeIntervalSince1970: archived/1000)
        }

        return instance

    }

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        id = aDecoder.decodeObjectForKey(Keys.Id) as? String
        name = aDecoder.decodeObjectForKey(Keys.Name) as? String
        moduleId = aDecoder.decodeObjectForKey(Keys.Module) as? String
        values = aDecoder.decodeObjectForKey(Keys.Values) as! [String: AnyObject]
        createdBy = aDecoder.decodeObjectForKey(Keys.CreatedBy) as? String
        updatedBy = aDecoder.decodeObjectForKey(Keys.UpdatedBy) as? String
        deletedBy = aDecoder.decodeObjectForKey(Keys.DeletedBy) as? String
        createdAt = aDecoder.decodeObjectForKey(Keys.CreatedAt) as? NSDate
        publishedAt = aDecoder.decodeObjectForKey(Keys.PublishedAt) as? NSDate
        removedAt = aDecoder.decodeObjectForKey(Keys.RemovedAt) as? NSDate
        updatedAt = aDecoder.decodeObjectForKey(Keys.UpdatedAt) as? NSDate
        deletedAt = aDecoder.decodeObjectForKey(Keys.DeletedAt) as? NSDate
        archivedAt = aDecoder.decodeObjectForKey(Keys.ArchivedAt) as? NSDate
        tags = aDecoder.decodeObjectForKey(Keys.Tags) as! [String: Halo.Tag]
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: Keys.Id)
        aCoder.encodeObject(name, forKey: Keys.Name)
        aCoder.encodeObject(moduleId, forKey: Keys.Module)
        aCoder.encodeObject(values, forKey: Keys.Values)
        aCoder.encodeObject(createdBy, forKey: Keys.CreatedBy)
        aCoder.encodeObject(updatedBy, forKey: Keys.UpdatedBy)
        aCoder.encodeObject(deletedBy, forKey: Keys.DeletedBy)
        aCoder.encodeObject(createdAt, forKey: Keys.CreatedAt)
        aCoder.encodeObject(publishedAt, forKey: Keys.PublishedAt)
        aCoder.encodeObject(removedAt, forKey: Keys.RemovedAt)
        aCoder.encodeObject(updatedAt, forKey: Keys.UpdatedAt)
        aCoder.encodeObject(deletedAt, forKey: Keys.DeletedAt)
        aCoder.encodeObject(archivedAt, forKey: Keys.ArchivedAt)
        aCoder.encodeObject(tags, forKey: Keys.Tags)
    }

    /**
    Provides information about whether the general content instance is removed or not

    - returns: Boolean determining if the instance is removed
    */
    public func isRemoved() -> Bool {
        if let removed = self.removedAt {
            return removed < NSDate()
        }

        return false
    }

    /**
    Provides information about whether the general content instance is published or not

    - returns: Boolean determining if the instance is published
    */
    public func isPublished() -> Bool {
        if let published = self.publishedAt {
            return published < NSDate()
        }

        return false
    }

    public func getValue(key: String) -> AnyObject? {
        return self.values[key]
    }

}
