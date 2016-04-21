//
//  SearchResult.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 19/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import RealmSwift

class PersistentSearchResult: Object {
    
    dynamic var id: Int = 0
    
    dynamic var instanceIds: String = ""
    
    dynamic var expirationDate: NSDate?
    
    convenience required init(hash: Int, instanceIds: [String]) {
        self.init()
        self.id = hash
        self.instanceIds = instanceIds.joinWithSeparator(",")
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
