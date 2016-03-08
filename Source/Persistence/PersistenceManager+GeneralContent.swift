//
//  DatabaseManager+GeneralContent.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 23/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

extension PersistenceManager {
    
    // MARK: Get instances in a module
    
    func generalContentInstances(moduleIds moduleIds: [String],
        flags: GeneralContentFlag? = [],
        fetchFromNetwork network: Bool,
        populate: Bool? = false,
        completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
            
            if !network {
                self.getInstancesLocalDataDontLoad(moduleIds, completionHandler: handler)
                return
            }
            
            Manager.network.generalContentInstances(moduleIds: moduleIds).response { (result) -> Void in
                switch result {
                case .Success(let data as [[String : AnyObject]], _):
                    
                    let instances = data.map({ GeneralContentInstance($0) })
                    
                    handler?(.Success(instances, false))
                    
                    try! self.realm.write({ () -> Void in
                        
                        self.realm.delete(self.realm.objects(PersistentGeneralContentInstance).filter("moduleId IN %@", moduleIds))
                        
                        for instance in instances {
                            self.realm.add(PersistentGeneralContentInstance(instance), update: true)
                        }
                    })
                case .Success(let data as [String : AnyObject], _):
                    
                    let items = data["items"] as! [[String : AnyObject]]
                    
                    let instances = items.map({ GeneralContentInstance($0) })
                    
                    handler?(.Success(instances, false))
                    
                    try! self.realm.write({ () -> Void in
                        
                        self.realm.delete(self.realm.objects(PersistentGeneralContentInstance).filter("moduleId IN %@", moduleIds))
                        
                        for instance in instances {
                            self.realm.add(PersistentGeneralContentInstance(instance), update: true)
                        }
                    })
                    
                    break
                case .Failure(let error):
                    if error.code == -1009 {
                        self.getInstancesLocalDataDontLoad(moduleIds, completionHandler: handler)
                    } else {
                        handler?(.Failure(error))
                    }
                default:
                    NSLog("Wrong response from server")
                    break
                }
            }
            
    }
    
    private func getInstancesLocalDataDontLoad(moduleIds: [String],
        completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
            
            let instances = realm.objects(PersistentGeneralContentInstance).filter("moduleId IN %@", moduleIds)
            
            let result = instances.map { (persistentInstance) -> Halo.GeneralContentInstance in
                return persistentInstance.getInstance()
            }
            
            handler?(.Success(result, true))
            
    }
    
    // MARK: Get a specific instance
    
    func generalContentInstance(instanceId: String,
        fetchFromNetwork network: Bool,
        populate: Bool? = false,
        completionHandler handler: ((Halo.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
        
        if !network {
            self.getInstanceLocalDataDontLoad(instanceId, completionHandler: handler)
            return
        }
        
        Manager.network.generalContentInstance(instanceId).response { (result) -> Void in
            switch result {
            case .Success(let data as [String : AnyObject], _):
                
                let instance = GeneralContentInstance(data)
                
                handler?(.Success(instance, false))
                
                try! self.realm.write({ () -> Void in
                    self.realm.add(PersistentGeneralContentInstance(instance), update: true)
                })
            case .Failure(let error):
                if error.code == -1009 {
                    self.getInstanceLocalDataDontLoad(instanceId, completionHandler: handler)
                } else {
                    handler?(.Failure(error))
                }
            default:
                NSLog("Wrong response from server")
                break
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
    
    func generalContentInstances(instanceIds instanceIds: [String],
        fetchFromNetwork network: Bool,
        flags: GeneralContentFlag? = [],
        populate: Bool? = false,
        completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
            
            if !network {
                self.getInstancesByIdsLocalDataDontLoad(instanceIds, completionHandler: handler)
                return
            }
            
            Manager.network.generalContentInstances(instanceIds: instanceIds, flags: flags).response { (result) -> Void in
                switch result {
                case .Success(let data as [[String : AnyObject]], _):
                    
                    let instances = data.map({ GeneralContentInstance($0) })
                    
                    handler?(.Success(instances, false))
                    
                    try! self.realm.write({ () -> Void in
                        
                        self.realm.delete(self.realm.objects(PersistentGeneralContentInstance).filter("id IN %@", instanceIds))
                        
                        for instance in instances {
                            self.realm.add(PersistentGeneralContentInstance(instance), update: true)
                        }
                    })
                case .Success(let data as [String : AnyObject], _):
                    
                    let items = data["items"] as! [[String : AnyObject]]
                    let instances = items.map({ GeneralContentInstance($0) })
                    
                    handler?(.Success(instances, false))
                    
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
                        handler?(.Failure(error))
                    }
                default:
                    NSLog("Wrong response from server")
                    break
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