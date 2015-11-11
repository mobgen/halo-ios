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
    
    /**
     Only load the data from the network, without even using any local storage
     
     - parameter handler: Closure to be executed after the request has finished
     */
    private func getModulesNoCache(completionHandler handler: (Alamofire.Result<[Halo.Module], NSError>) -> Void) -> Void {
        net.getModules { result in
            handler(result)
        }
    }
    
    /**
     Get the latest information from the server and store it locally, in order to keep providing data in case
     there is no internet connection.
     
     - parameter handler: Closure to be executed after the request has finished
     */
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
    
    /**
     Get the modules from the local storage. If there are no results from there, try to load from network,
     storing the new results
     
     - parameter handler: Closure to be executed after the request has finished
     */
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
    
    /**
     Get the modules only from the local storage, not even trying to load any data from the network
     
     - parameter handler: Closure to be executed after the request has finished
     */
    private func getModulesLocalDataDontLoad(completionHandler handler: (Alamofire.Result<[Halo.Module], NSError>) -> Void) -> Void {
        let modules = realm.objects(PersistentModule)
        
        let result = modules.map { (persistentModule) -> Halo.Module in
            return persistentModule.getModule()
        }
        
        handler(.Success(result))
    }
    
}