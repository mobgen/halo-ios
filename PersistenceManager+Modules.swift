//
//  DatabaseManager+Modules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 23/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

extension PersistenceManager: ModulesManager {
    
    func getModules(fetchFromNetwork network: Bool, completionHandler handler: ((Alamofire.Result<[Halo.Module], NSError>, Bool) -> Void)?) -> Void {
        
        if !network {
            self.getModulesLocalDataDontLoad(completionHandler: { (result) -> Void in
                handler?(result, true)
            })
            return
        }
        
        net.getModules { (result, _) in
            switch result {
            case .Success(let modules):
                handler?(.Success(modules), false)
                
                try! self.realm.write({ () -> Void in
                    
                    // Delete the existing ones. Temporary solution?
                    self.realm.delete(self.realm.objects(PersistentModule))
                    
                    for module in modules {
                        self.realm.add(PersistentModule(module), update: true)
                    }
                })
                
            case .Failure(let error):
                if error.code == -1009 {
                    self.getModulesLocalDataDontLoad(completionHandler: { (result) -> Void in
                        handler?(result, true)
                    })
                } else {
                    handler?(.Failure(error), false)
                }
            }
        }
    }
    
 
    private func getModulesLocalDataDontLoad(completionHandler handler: ((Alamofire.Result<[Halo.Module], NSError>) -> Void)?) -> Void {
        
        let modules = realm.objects(PersistentModule)
        
        let result = modules.map { (persistentModule) -> Halo.Module in
            return persistentModule.getModule()
        }
        
        handler?(.Success(result))
        
    }
    
}
