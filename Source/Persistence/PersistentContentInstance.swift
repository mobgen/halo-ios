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
    
    let values = List<PersistentContentValue>()
    
    let tags = List<PersistentTag>()
    
    convenience required init(instance: Halo.ContentInstance) {
        self.init()
        
        self.id = instance.id ?? ""
        self.moduleId = instance.moduleId ?? ""
        self.name = instance.name ?? ""
        self.createdBy = instance.createdBy
        self.createdAt = instance.createdAt
        self.publishedAt = instance.publishedAt
        self.removedAt = instance.removedAt
        self.updatedAt = instance.updatedAt
        
        self.values.appendContentsOf(instance.values.map { PersistentContentValue(key: $0, value: $1.description) })
        self.tags.appendContentsOf(instance.tags.map { PersistentTag(tag: $1) })
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
