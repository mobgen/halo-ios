//
//  PersistentTag.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 05/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import RealmSwift

class PersistentTag: Object {
 
    /// Id of the user tag instance
    dynamic var id: String = ""
    
    /// Name of the tag
    dynamic var name: String = ""
    
    /// Value given to the tag
    dynamic var value: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    init(tag: Halo.Tag) {
        super.init()
        self.id = tag.id!
        self.name = tag.name
        self.value = tag.value
    }
    
    required init() {
        super.init()
    }
    
    func getTag() -> Halo.Tag {
        
        let tag = Halo.Tag()
        
        tag.id = self.id
        tag.name = self.name
        tag.value = self.value
        
        return tag
    }
    
}