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
    
    private func loadAndStoreData(request urlRequest: Halo.Request,
        completionHandler handler: ((Halo.Result<NSData, NSError>) -> Void)? = nil) {
            
            Manager.network.startRequest(request: urlRequest) { (response, result) -> Void in
                handler?(result)
                
                switch result {
                case .Success(let data, _):
                
                    let realm = try! Realm()
                    
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
