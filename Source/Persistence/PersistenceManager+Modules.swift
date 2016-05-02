//
//  PersistenceManager+Modules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 20/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import RealmSwift

extension PersistenceManager: ModulesProvider {
    
    func getModules(offlinePolicy: OfflinePolicy?) -> Halo.Request {
        return Halo.Request(path: "blah")
    }
    
}
