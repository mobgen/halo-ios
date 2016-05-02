//
//  PersistentContentValue.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 21/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import RealmSwift

class PersistentContentValue: Object {
    
    dynamic var key: String = ""
    
    dynamic var value: String?
    
    convenience required init(key: String, value: String?) {
        self.init()
        self.key = key
        self.value = value
    }
    
}
