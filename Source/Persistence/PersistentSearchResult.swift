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
    
    convenience required init(hash: Int, instanceIds: [String], ttl: Double = 0) {
        self.init()
        self.id = hash
        self.instanceIds = instanceIds.joinWithSeparator(",")
        self.expirationDate = NSDate(timeIntervalSinceNow: ttl * 1000)
    }

    func getInstanceIds() -> [String] {
        return self.instanceIds.componentsSeparatedByString(",")
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
