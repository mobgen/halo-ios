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

    init() {}
    
    func startup(completionHandler handler: ((Bool) -> Void)? = nil) -> Void {
        setupRealm(Manager.core.environment)
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
    
    func startRequest(request urlRequest: Halo.Request,
        useNetwork: Bool,
        completionHandler handler: ((Halo.Result<NSData, NSError>) -> Void)? = nil) -> Void {

            if (useNetwork) {
                self.loadAndStoreData(request: urlRequest, completionHandler: handler)
            } else {
                self.localDataDontLoad(request: urlRequest, completionHandler: handler)
            }
            
    }
    
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
    
    private func loadAndStoreData(request urlRequest: Halo.Request,
        completionHandler handler: ((Halo.Result<NSData, NSError>) -> Void)? = nil) {
        
            Manager.network.startRequest(request: urlRequest) { (response, result) -> Void in
                handler?(result)
            
                let realm = try! Realm()
                
                switch result {
                case .Success(let data, _):
                
                    try! realm.write({ () -> Void in
                        realm.add(PersistentRequest(request: urlRequest, response: data), update: true)
                    })
                
                case .Failure(let error):
                    if error.code == -1009 {
                        self.localDataDontLoad(request: urlRequest, completionHandler: handler)
                    } else {
                        handler?(result)
                    }
                }
            }
    }
    
    private func localDataDontLoad(request urlRequest: Halo.Request,
        completionHandler handler: ((Halo.Result<NSData, NSError>) -> Void)? = nil) {
        
            let realm = try! Realm()
        
            if let persistentRequest = realm.objectForPrimaryKey(PersistentRequest.self, key: urlRequest.hash()), data = persistentRequest.data {
                handler?(.Success(data, true))
            } else {
                handler?(.Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: "No cached data found"])))
            }
    }
    
}
