//
//  PersistentModule.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 05/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import RealmSwift

class PersistentModule: Object {
    
    /// Unique identifier of the module
    dynamic var id: Int = 0
    
    /// Visual name of the module
    dynamic var name: String? = nil
    
    /// Type of the module
    dynamic var type: Halo.PersistentModuleType? = nil
    
    /// Identifies the module as enabled or not
    dynamic var enabled: Bool = false
    
    /// Identifies the module as single item module
    dynamic var isSingle: Bool = false
    
    /// Date of the last update performed in this module
    dynamic var lastUpdate: NSDate? = nil
    
    /// Internal id of the module
    dynamic var internalId: String? = nil
    
    /// Dictionary of tags associated to this module
    let tags: List<PersistentTag> = List<PersistentTag>()

    dynamic var ttl: NSDate = NSDate(timeIntervalSinceNow: 86400)
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(_ module: Halo.Module) {
        self.init()
        self.id = (module.id?.integerValue)!
        self.name = module.name
        self.type = PersistentModuleType(type: module.type!)
        self.enabled = module.enabled
        self.isSingle = module.isSingle
        self.lastUpdate = module.lastUpdate
        self.internalId = module.internalId
        
        for (_, tag) in module.tags {
            tags.append(PersistentTag(tag))
        }
    }

    func getModule() -> Halo.Module {
        
        let module = Halo.Module()
        
        module.id = self.id
        module.name = self.name
        
        module.enabled = self.enabled
        module.isSingle = self.isSingle
        module.lastUpdate = self.lastUpdate
        module.internalId = self.internalId
        
        module.tags = [:]
        
        for tag in self.tags {
            module.tags[tag.name] = Tag(name: tag.name, value: tag.value)
        }
        
        return module
    }
}