//
//  DatabaseManager+GeneralContent.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 23/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

extension PersistenceManager: GeneralContentManager {
    
    // MARK: Get instances in a module
    
    func generalContentInstances(moduleIds: [String], flags: GeneralContentFlag, fetchFromNetwork network: Bool, populate: Bool? = false, completionHandler handler: ((Halo.Result<[GeneralContentInstance], NSError>) -> Void)?) -> Void {
        
        if !network {
            self.getInstancesLocalDataDontLoad(moduleIds, completionHandler: handler)
            return
        }
        
        net.generalContentInstances(moduleIds, flags: []) { (result) -> Void in
            switch result {
            case .Success(let instances, _):
                handler?(result)
                
                try! self.realm.write({ () -> Void in
                    
                    self.realm.delete(self.realm.objects(PersistentGeneralContentInstance).filter("moduleId IN %@", moduleIds))
                    
                    for instance in instances {
                        self.realm.add(PersistentGeneralContentInstance(instance), update: true)
                    }
                })
            case .Failure(let error):
                if error.code == -1009 {
                    self.getInstancesLocalDataDontLoad(moduleIds, completionHandler: handler)
                } else {
                    handler?(result)
                }
            }
        }
        
    }
    
    private func getInstancesLocalDataDontLoad(moduleIds: [String], completionHandler handler: ((Halo.Result<[GeneralContentInstance], NSError>) -> Void)?) -> Void {
        
        let instances = realm.objects(PersistentGeneralContentInstance).filter("moduleId IN %@", moduleIds)
        
        let result = instances.map { (persistentInstance) -> Halo.GeneralContentInstance in
            return persistentInstance.getInstance()
        }
        
        handler?(.Success(result, true))
        
    }
    
    // MARK: Get a specific instance
    
    func generalContentInstance(instanceId: String, fetchFromNetwork network: Bool, populate: Bool? = false, completionHandler handler: ((Halo.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
        
        if !network {
            self.getInstanceLocalDataDontLoad(instanceId, completionHandler: handler)
            return
        }
        
        net.generalContentInstance(instanceId) { (result) -> Void in
            switch result {
            case .Success(let instance, _):
                handler?(result)
                
                try! self.realm.write({ () -> Void in
                    self.realm.add(PersistentGeneralContentInstance(instance), update: true)
                })
                
            case .Failure(let error):
                if error.code == -1009 {
                    self.getInstanceLocalDataDontLoad(instanceId, completionHandler: handler)
                } else {
                    handler?(result)
                }
            }
        }
        
    }
    
    private func getInstanceLocalDataDontLoad(instanceId: String, completionHandler handler: ((Halo.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
        
        if let instance = realm.objectForPrimaryKey(PersistentGeneralContentInstance.self, key: instanceId) {
            handler?(.Success(instance.getInstance(), true))
        } else {
            handler?(.Failure(NSError(domain: "com.mobgen", code: 0, userInfo: nil)))
        }
        
    }
    
    // MARK: Get instances by ids
    
    func generalContentInstances(instanceIds: [String], fetchFromNetwork network: Bool, populate: Bool? = false, completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
        
        if !network {
            self.getInstancesByIdsLocalDataDontLoad(instanceIds, completionHandler: handler)
            return
        }
        
        net.generalContentInstances(instanceIds) { (result) -> Void in
            switch result {
            case .Success(let instances, _):
                
                handler?(result)
                
                try! self.realm.write({ () -> Void in
                    
                    self.realm.delete(self.realm.objects(PersistentGeneralContentInstance).filter("id IN %@", instanceIds))
                    
                    for instance in instances {
                        self.realm.add(PersistentGeneralContentInstance(instance), update: true)
                    }
                })
                
            case .Failure(let error):
                if error.code == -1009 {
                    self.getInstancesByIdsLocalDataDontLoad(instanceIds, completionHandler: handler)
                } else {
                    handler?(result)
                }
            }
        }
    }
    
    private func getInstancesByIdsLocalDataDontLoad(instanceIds: [String], completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
    
        let instances = realm.objects(PersistentGeneralContentInstance).filter("id IN %@", instanceIds)
        
        let result = instances.map { (persistentInstance) -> Halo.GeneralContentInstance in
            return persistentInstance.getInstance()
        }
        
        handler?(.Success(result, true))
        
    }

}