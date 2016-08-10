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

public struct ContentInstance {

    /// Unique identifier of this General Content instance
    public internal(set) var id: String?

    /// Id of the module to which this instance belongs
    public var moduleId: String?

    /// Name of the instance
    public var name: String?

    /// Collection of key-value pairs which make up the information of this instance
    public var values: [String: AnyObject]

    /// Name of the creator of the content
    public var createdBy: String?

    /// Date in which the content was created
    public var createdAt: NSDate?

    /// Date in which the content was (or is going to be) published
    public var publishedAt: NSDate?

    /// Date in which the content was (or is going to be) removed
    public var removedAt: NSDate?

    /// Most recent date in which the content was updated
    public var updatedAt: NSDate?

    /// Dictionary of tags associated to this general content instance
    public var tags: [String: Halo.Tag] = [:]

    public init(_ dict: [String: AnyObject]) {

        id = dict["id"] as? String
        moduleId = dict["module"] as? String
        name = dict["name"] as? String
        values = dict["values"] as? [String: AnyObject] ?? [:]
        createdBy = dict["createdBy"] as? String

        if let tagsList = dict["tags"] as? [[String: AnyObject]] {
            tags = tagsList.map { Halo.Tag.fromDictionary($0) }.reduce([:]) { (tagsDict, tag: Halo.Tag) -> [String: Halo.Tag] in
                var varDict = tagsDict
                varDict[tag.name] = tag
                return varDict
            }
        }

        if let created = dict["createdAt"] as? Double {
            createdAt = NSDate(timeIntervalSince1970: created/1000)
        }

        if let updated = dict["updatedAt"] as? Double {
            updatedAt = NSDate(timeIntervalSince1970: updated/1000)
        }

        if let published = dict["publishedAt"] as? Double {
            publishedAt = NSDate(timeIntervalSince1970: published/1000)
        }

        if let removed = dict["removedAt"] as? Double {
            removedAt = NSDate(timeIntervalSince1970: removed/1000)
        }

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
