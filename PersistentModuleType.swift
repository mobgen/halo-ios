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
    var category: RealmOptional<Int>
    
    /// Flag determining whether the module type is enabled or not
    var enabled: Bool = false
    
    /// Visual name of the module type
    var name: String?
    
    /// Url of the module type
    var typeUrl: String?

    override static func primaryKey() -> String? {
        return "category"
    }
 
    init(type: Halo.ModuleType) {
        category = RealmOptional<Int>()
        super.init()
        self.category.value = type.category?.rawValue
        self.enabled = type.enabled
        self.name = type.name
        self.typeUrl = type.typeUrl
    }
    
    required init() {
        category = RealmOptional<Int>()
        super.init()
    }

}