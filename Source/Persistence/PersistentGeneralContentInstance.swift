//
//  PersistentGeneralContentInstance.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 13/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import RealmSwift

class PersistentGeneralContentInstance: Object {
    
    /// Unique identifier of this General Content instance
    dynamic var id: String = ""
    
    /// Id of the module to which this instance belongs
    dynamic var moduleId: String?
    
    /// Name of the instance
    dynamic var name: String?
    
    /// Collection of key-value pairs which make up the information of this instance
    let values: List<PersistentValue> = List<PersistentValue>()
    
    /// Name of the creator of the content
    dynamic var createdBy: String?
    
    /// Date in which the content was created
    dynamic var createdAt: NSDate?
    
    /// Date in which the content was (or is going to be) published
    dynamic var publishedAt: NSDate?
    
    /// Date in which the content was (or is going to be) removed
    dynamic var removedAt: NSDate?
    
    /// Most recent date in which the content was updated
    dynamic var updatedAt: NSDate?
    
    dynamic var ttl: NSDate = NSDate(timeIntervalSinceNow: 86400)
    
    /// Dictionary of tags associated to this general content instance
    let tags: List<PersistentTag> = List<PersistentTag>()
    
    convenience required init(_ instance: Halo.GeneralContentInstance) {
    
        self.init()
        self.id = instance.id!
        self.moduleId = instance.moduleId
        self.name = instance.name
        
        for (k, v) in instance.values {
            self.values.append(PersistentValue(key: k, value: v))
        }
        
        self.createdBy = instance.createdBy
        self.createdAt = instance.createdAt
        self.publishedAt = instance.publishedAt
        self.removedAt = instance.removedAt
        self.updatedAt = instance.updatedAt
        
        for (_, tag) in instance.tags {
            self.tags.append(PersistentTag(tag))
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func getInstance() -> Halo.GeneralContentInstance {
        
        let instance = Halo.GeneralContentInstance()
        
        instance.id = self.id
        instance.moduleId = self.moduleId
        instance.name = self.name
        
        for value in self.values {
            instance.values[value.key] = (value.stringValue ?? value.doubleValue.value) ?? value.floatValue.value
        }
        
        instance.createdBy = self.createdBy
        instance.createdAt = self.createdAt
        instance.publishedAt = self.publishedAt
        instance.removedAt = self.removedAt
        instance.updatedAt = self.updatedAt
        
        for tag in self.tags {
            instance.tags[tag.name] = tag.getTag()
        }
        
        return instance
    }
    
}