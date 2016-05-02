//
//  PersistentRequest.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 11/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import RealmSwift

class PersistentRequest: Object {
    
    /// Unique identifier of this General Content instance
    dynamic var id: Int = 0
    dynamic var data: NSData? = nil
    dynamic var ttl: Int = 86400
    
    convenience required init(request: Halo.Request, response: NSData, ttl: Int? = nil) {
        self.init()
        self.id = request.hash()
        self.data = response
        
        if let t = ttl {
            self.ttl = t
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}