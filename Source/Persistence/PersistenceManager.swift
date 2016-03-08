//
//  DatabaseManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 23/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import RealmSwift

class PersistenceManager: HaloManager {

    let realm = try! Realm.init()

    init() {}
    
    func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {
        
    }
    
    func setupRealm(environment: HaloEnvironment) {
        var config = Realm.Configuration()
        
        // Use the default directory, but replace the filename with the environment name
        config.path = NSURL.fileURLWithPath(config.path!)
            .URLByDeletingLastPathComponent?
            .URLByAppendingPathComponent("\(environment.description).realm")
            .path
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
    }
    
}

//class PersistenceManager {
//    
//    static let sharedInstance = PersistenceManager()
//    
//    let realm = try! Realm.init()
//    
//    let net = NetworkManager.instance
//    
//    private init() {
//        
//    }
//
//    func clearDatabase() {
//        try! self.realm.write { () -> Void in
//            self.realm.deleteAll()
//        }
//    }
//    
//}