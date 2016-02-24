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
    dynamic var stringValue: String? = nil
    let doubleValue = RealmOptional<Double>()
    let floatValue = RealmOptional<Float>()
    
    convenience required init(key: String, value: AnyObject?) {
        self.init()
        self.key = key
        
        if let val = value {
            switch value {
            case is Double:
                self.doubleValue.value = val as? Double
            case is Float:
                self.floatValue.value = val as? Float
            default:
                self.stringValue = val.description
            }
        }
    }
    
}