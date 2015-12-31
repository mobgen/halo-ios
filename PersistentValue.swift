//
//  PersistentValue.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 13/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import RealmSwift

class PersistentValue: Object {
    
    dynamic var key: String = ""
    dynamic var value: AnyObject = ""
    
    convenience required init(key: String, value: AnyObject) {
        self.init()
        self.key = key
        self.value = value
    }
    
}