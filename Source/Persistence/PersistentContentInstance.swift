//
//  PersistentContentInstance.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 19/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import RealmSwift

class PersistentContentInstance: Object {
 
    dynamic var id: String = ""
    
    dynamic var moduleId: String = ""
    
    dynamic var name: String = ""
    
    dynamic var createdBy: String?
    
    dynamic var createdAt: NSDate?
    
    dynamic var publishedAt: NSDate?
    
    dynamic var removedAt: NSDate?
    
    dynamic var updatedAt: NSDate?
    
    dynamic var expirationDate: NSDate?
    
    let values = List<PersistentContentValue>()
    
    let tags = List<PersistentTag>()
    
    convenience required init(instance: Halo.ContentInstance, ttl: Double = 0) {
        self.init()
        
        self.id = instance.id ?? ""
        self.moduleId = instance.moduleId ?? ""
        self.name = instance.name ?? ""
        self.createdBy = instance.createdBy
        self.createdAt = instance.createdAt
        self.publishedAt = instance.publishedAt
        self.removedAt = instance.removedAt
        self.updatedAt = instance.updatedAt
        self.expirationDate = NSDate(timeIntervalSinceNow: ttl * 1000)
        
        self.values.appendContentsOf(instance.values.map { PersistentContentValue(key: $0, value: $1.description) })
        self.tags.appendContentsOf(instance.tags.map { PersistentTag(tag: $1) })
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func getModel() -> Halo.ContentInstance {
        
        let instance = Halo.ContentInstance()

        instance.id = self.id
        instance.moduleId = self.moduleId
        instance.name = self.name
        instance.createdBy = self.createdBy
        instance.createdAt = self.createdAt
        instance.publishedAt = self.publishedAt
        instance.removedAt = self.removedAt
        instance.updatedAt = self.updatedAt
        
        instance.values = self.values.reduce([:], combine: { (dict, value) -> [String: AnyObject] in
            var newDict = dict
            newDict[value.key] = value.value
            return newDict
        })
        
        instance.tags = self.tags.reduce([:], combine: { (dict, tag) -> [String: Halo.Tag] in
            var newDict = dict
            newDict[tag.id] = tag.getModel()
            return newDict
        })
        
        return instance
    }

}
