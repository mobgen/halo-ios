//
//  DatabaseManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 23/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import RealmSwift

class PersistenceManager {
    
    static let sharedInstance = PersistenceManager()
    
    let realm = try! Realm.init()
    
    let net = NetworkManager.instance
    
    private init() {
        
    }
    
    func clearDatabase() {
        try! self.realm.write { () -> Void in
            self.realm.deleteAll()
        }
    }
    
}