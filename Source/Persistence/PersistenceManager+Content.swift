//
//  PersistenceManager+Content.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 20/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import RealmSwift

extension PersistenceManager: ContentProvider {
    
    func syncModule(moduleId: String, completionHandler handler: (() -> Void)? = nil) -> Void {
        
        let request = Halo.Request(router: Router.ModuleSync)
        var params: [String: AnyObject] = ["moduleId": moduleId]
        
        let realm = try! Realm()
        
        var persistentSync = realm.objectForPrimaryKey(PersistentSync.self, key: moduleId)
        
        if let sync = persistentSync {
            params["fromSync"] = sync.lastSync
        } else {
            params["fromSync"] = 0
            persistentSync = PersistentSync(moduleId: moduleId)
        }
        
        request.params(params).response { (result) in
            
            let realm = try! Realm()
            
            // Process the request
            switch result {
            case .Success(let values as [String: AnyObject], _):
                
                try! realm.write({
                    // Persist/update the sync
                    persistentSync!.lastSync = values["syncTimestamp"] as! Double
                    
                    realm.add(persistentSync!, update: true)
                })
                
                NSLog("Values: \(values)")
                
            case .Failure(let error):
                NSLog("Error sync'ing: \(error.localizedDescription)")
            default:
                break
            }
        }
    }
    
    func clearSyncedModule(moduleId: String, completionHandler handler: (() -> Void)? = nil) -> Void {
        
        let realm = try! Realm()
        
        if let sync = realm.objectForPrimaryKey(PersistentSync.self, key: moduleId) {
            let realm = try! Realm()
            
            realm.delete(sync)
        }
    }
    
    func getInstances(searchOptions: Halo.SearchOptions) -> Request {
        return Halo.Request(path: "blah")
    }
    
}
