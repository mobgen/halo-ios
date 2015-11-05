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
    let id: RealmOptional<Double>
    
    /// Visual name of the module
    var name: String?
    
    /// Type of the module
    var type: Halo.PersistentModuleType?
    
    /// Identifies the module as enabled or not
    var enabled: Bool = false
    
    /// Identifies the module as single item module
    var isSingle: Bool = false
    
    /// Date of the last update performed in this module
    var lastUpdate: NSDate?
    
    /// Internal id of the module
    var internalId: String?
    
    /// Dictionary of tags associated to this module
    var tags: [String: Halo.PersistentTag] = [:]

    override static func primaryKey() -> String? {
        return "id"
    }
    
    init(module: Halo.Module) {
        id = RealmOptional<Double>()
        super.init()
        self.id.value = module.id?.doubleValue
        self.name = module.name
        self.type = PersistentModuleType(type: module.type!)
        self.enabled = module.enabled
        self.isSingle = module.isSingle
        self.lastUpdate = module.lastUpdate
        self.internalId = module.internalId
    }

    required init() {
        id = RealmOptional<Double>()
        super.init()
    }
}