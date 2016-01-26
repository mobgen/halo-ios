//
//  PersistentModuleType.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 05/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import RealmSwift

class PersistentModuleType: Object {
    
    /// Unique identifier of the module type
    dynamic var category: Int = 0
    
    /// Flag determining whether the module type is enabled or not
    dynamic var enabled: Bool = false
    
    /// Visual name of the module type
    dynamic var name: String? = nil
    
    /// Url of the module type
    dynamic var typeUrl: String? = nil

    override static func primaryKey() -> String? {
        return "category"
    }
 
    init(type: Halo.ModuleType) {
        super.init()
        
        if let cat = type.category {
            self.category = cat.rawValue
        }
        
        self.enabled = type.enabled
        self.name = type.name
        self.typeUrl = type.typeUrl
    }
    
    required init() {
        super.init()
    }

    func getModuleType() -> Halo.ModuleType {
        
        let type = Halo.ModuleType()

        type.category = Halo.ModuleTypeCategory(rawValue: self.category)
        type.enabled = self.enabled
        type.name = self.name
        type.typeUrl = self.typeUrl
        
        return type
    }
    
}