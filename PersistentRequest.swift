//
//  PersistentRequest.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 26/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import RealmSwift

class PersistentRequest: Object {
    
    dynamic var path: String = ""
    
    dynamic var response: NSData? = nil
    
    dynamic var requestHash: Int = 0
    
    override static func primaryKey() -> String? {
        return "hash"
    }
    
    convenience init(request: Request) {
        let req = request.URLRequest
        
    }
    
    required init() {
        super.init()
    }
    
}