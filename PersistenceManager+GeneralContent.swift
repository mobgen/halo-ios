//
//  DatabaseManager+GeneralContent.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 23/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

extension PersistenceManager: GeneralContentManager {
    
    // MARK: Get instances in a module
    
    func generalContentInstances(moduleId: String, flags: GeneralContentFlag, fetchFromNetwork network: Bool, completionHandler handler: ((Alamofire.Result<[GeneralContentInstance], NSError>) -> Void)?) -> Void {
        
        if !network {
            self.getInstancesLocalDataDontLoad(moduleId, completionHandler: handler)
            return
        }
        
        net.generalContentInstances(moduleId, flags: []) { (result) -> Void in
            switch result {
            case .Success(let instances):
                handler?(.Success(instances))
                
                try! self.realm.write({ () -> Void in
                    
                    self.realm.delete(self.realm.objects(PersistentGeneralContentInstance).filter("moduleId = '\(moduleId)'"))
                    
                    for instance in instances {
                        self.realm.add(PersistentGeneralContentInstance(instance), update: true)
                    }
                })
            case .Failure(let error):
                if error.code == -1009 {
                    self.getInstancesLocalDataDontLoad(moduleId, completionHandler: handler)
                } else {
                    handler?(.Failure(error))
                }
            }
        }
        
    }
    
    private func getInstancesLocalDataDontLoad(moduleId: String, completionHandler handler: ((Alamofire.Result<[GeneralContentInstance], NSError>) -> Void)?) -> Void {
        
        let instances = realm.objects(PersistentGeneralContentInstance).filter("moduleId = '\(moduleId)'")
        
        let result = instances.map { (persistentInstance) -> Halo.GeneralContentInstance in
            return persistentInstance.getInstance()
        }
        
        handler?(.Success(result))
        
    }
    
    // MARK: Get a specific instance
    
    func generalContentInstance(instanceId: String, fetchFromNetwork network: Bool, completionHandler handler: ((Alamofire.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
        
        if !network {
            self.getInstanceLocalDataDontLoad(instanceId, completionHandler: handler)
            return
        }
        
        net.generalContentInstance(instanceId) { (result) -> Void in
            switch result {
            case .Success(let instance):
                handler?(.Success(instance))
                
                try! self.realm.write({ () -> Void in
                    self.realm.add(PersistentGeneralContentInstance(instance), update: true)
                })
                
            case .Failure(let error):
                if error.code == -1009 {
                    self.getInstanceLocalDataDontLoad(instanceId, completionHandler: handler)
                } else {
                    handler?(.Failure(error))
                }
            }
        }
        
    }
    
    private func getInstanceLocalDataDontLoad(instanceId: String, completionHandler handler: ((Alamofire.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
        
        if let instance = realm.objectForPrimaryKey(PersistentGeneralContentInstance.self, key: instanceId) {
            handler?(.Success(instance.getInstance()))
        } else {
            handler?(.Failure(NSError(domain: "com.mobgen", code: 0, userInfo: nil)))
        }
        
    }
    
    // MARK: Get instances by ids
    
    func generalContentInstances(instanceIds: [String], fetchFromNetwork network: Bool, completionHandler handler: ((Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
        
        if !network {
            self.getInstancesByIdsLocalDataDontLoad(instanceIds, completionHandler: handler)
            return
        }
        
        net.generalContentInstances(instanceIds) { (result) -> Void in
            switch result {
            case .Success(let instances):
                
                handler?(.Success(instances))
                
                try! self.realm.write({ () -> Void in
                    
                    self.realm.delete(self.realm.objects(PersistentGeneralContentInstance).filter("id IN \(instanceIds)"))
                    
                    for instance in instances {
                        self.realm.add(PersistentGeneralContentInstance(instance), update: true)
                    }
                })
                
            case .Failure(let error):
                if error.code == -1009 {
                    self.getInstancesByIdsLocalDataDontLoad(instanceIds, completionHandler: handler)
                } else {
                    handler?(.Failure(error))
                }
            }
        }
        
        
    }
    
    private func getInstancesByIdsLocalDataDontLoad(instanceIds: [String], completionHandler handler: ((Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
    
        let instances = realm.objects(PersistentGeneralContentInstance).filter("id IN \(instanceIds)")
        
        let result = instances.map { (persistentInstance) -> Halo.GeneralContentInstance in
            return persistentInstance.getInstance()
        }
        
        handler?(.Success(result))
        
    }

}