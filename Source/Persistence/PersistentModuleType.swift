//
//  PersistentModuleType.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 21/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import RealmSwift

class PersistentModuleType: Object {
    
    dynamic var category: Int = 0
    
    dynamic var enabled: Bool = false
    
    dynamic var name: String = ""
    
    dynamic var typeUrl: String = ""
    
    convenience required init(type: Halo.ModuleType) {
        self.init()
        
        self.category = type.category?.rawValue ?? 0
        self.enabled = type.enabled
        self.name = type.name ?? ""
        self.typeUrl = type.typeUrl ?? ""
    }
    
}
