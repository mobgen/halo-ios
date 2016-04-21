//
//  PersistentTag.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 21/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import RealmSwift

class PersistentTag: Object {
    
    dynamic var id: String = ""
    
    dynamic var name: String = ""
    
    dynamic var value: String?
    
    convenience required init(tag: Halo.Tag) {
        self.init()
        self.id = tag.id ?? ""
        self.name = tag.name
        self.value = tag.value
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func getModel() -> Halo.Tag {
        
        let tag = Halo.Tag()
        
        tag.id = self.id
        tag.name = self.name
        tag.value = self.value
        
        return tag
    }
}
