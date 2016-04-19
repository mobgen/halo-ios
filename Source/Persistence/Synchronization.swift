//
//  Synchronization.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 18/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import RealmSwift

class Synchronization: Object {
    
    dynamic var moduleId: String = ""
    dynamic var lastSync: Double = 0
    
    convenience required init(moduleId: String, lastSync: Double? = nil) {
        self.init()
        self.moduleId = moduleId
        self.lastSync = lastSync ?? 0
    }
    
    override static func primaryKey() -> String? {
        return "moduleId"
    }
    
}