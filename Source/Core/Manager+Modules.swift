//
//  Manager+Modules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 11/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

extension Manager {
 
    /**
     Get a list of the existing modules for the provided client credentials
     
     - parameter completionHandler:  Closure to be executed when the request has finished
     */
    public func getModules(offlinePolicy: OfflinePolicy = .LoadAndStoreLocalData, completionHandler handler: (Alamofire.Result<[Halo.Module], NSError>) -> Void) -> Void {
        
        switch offlinePolicy {
        case .None:
            getModulesNoCache(completionHandler: handler)
        case .LoadAndStoreLocalData:
            getModulesLoadAndStoreLocalData(completionHandler: handler)
        case .ReturnLocalDataElseLoad:
            getModulesLocalDataElseLoad(completionHandler: handler)
        case .ReturnLocalDataDontLoad:
            getModulesLocalDataDontLoad(completionHandler: handler)
            
        }
    }
    
    private func getModulesNoCache(completionHandler handler: (Alamofire.Result<[Halo.Module], NSError>) -> Void) -> Void {
        net.getModules { result in
            handler(result)
        }
    }
    
    private func getModulesLoadAndStoreLocalData(completionHandler handler: (Alamofire.Result<[Halo.Module], NSError>) -> Void) -> Void {
        net.getModules { result in
            switch result {
            case .Success(let modules):
                handler(.Success(modules))
                
                try! self.realm.write({ () -> Void in
                    
                    // Delete the existing ones. Temporary solution?
                    self.realm.delete(self.realm.objects(PersistentModule))
                    
                    for module in modules {
                        self.realm.add(PersistentModule(module), update: true)
                    }
                })
                
            case .Failure(let error):
                if error.code == -1009 {
                    self.getModulesLocalDataDontLoad(completionHandler: handler)
                } else {
                    handler(.Failure(error))
                }
            }
        }
    }
    
    private func getModulesLocalDataElseLoad(completionHandler handler: (Alamofire.Result<[Halo.Module], NSError>) -> Void) -> Void {
        
        let modules = realm.objects(PersistentModule)
        
        let result = modules.map { (persistentModule) -> Halo.Module in
            return persistentModule.getModule()
        }
        
        if result.count > 0 {
            handler(.Success(result))
        } else {
            self.getModulesLoadAndStoreLocalData(completionHandler: handler)
        }
        
    }
    
    private func getModulesLocalDataDontLoad(completionHandler handler: (Alamofire.Result<[Halo.Module], NSError>) -> Void) -> Void {
        let modules = realm.objects(PersistentModule)
        
        let result = modules.map { (persistentModule) -> Halo.Module in
            return persistentModule.getModule()
        }
        
        handler(.Success(result))
    }
    
}