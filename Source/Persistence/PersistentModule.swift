//
//  PersistentModule.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 19/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import RealmSwift

class PersistentModule: Object {
    
    dynamic var id: Double = 0
    
    dynamic var name: String?
    
    dynamic var moduleType: PersistentModuleType?
    
    dynamic var enabled: Bool = false
    
    dynamic var isSingle: Bool = false
    
    dynamic var lastUpdate: NSDate?
    
    dynamic var internalId: String?
    
    dynamic var expirationDate: NSDate?
    
    let tags = List<PersistentTag>()
    
    convenience required init(module: Halo.Module) {
        self.init()
        
        if let id = module.id?.doubleValue {
            self.id = id
        }
        
        self.internalId = module.internalId
        
        self.name = module.name
        
        if let type = module.type {
            self.moduleType = PersistentModuleType(type: type)
        }
        
        self.enabled = module.enabled
        self.isSingle = module.isSingle
        self.lastUpdate = module.lastUpdate
        
        tags.appendContentsOf(module.tags.map { PersistentTag(tag: $1) })
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}