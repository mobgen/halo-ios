//
//  GeneralContent.swift
//  HaloSDK
//
//  Created by Borja on 31/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

/**
 Access point to the General Content. This class will provide methods to obtain the data stored as general content.
 */
@objc(HaloGeneralContent)
public class GeneralContent: NSObject {

    /// Shortcut for the shared instance of the network manager
    private let net = Halo.NetworkManager.instance

    /// Shared instance of the General Content component (Singleton pattern)
    public static let sharedInstance = GeneralContent()

    private override init() {}

    private let realm = try! Realm()
    
    // MARK: Get instances
    
    /**
    Get the existing instances of a given General Content module

    - parameter moduleId:           Internal id of the module from which we want to retrieve the instances
    - parameter completionHandler:  Closure to be executed when the request has finished
    */
    public func getInstances(moduleId moduleId: String, offlinePolicy: OfflinePolicy = .LoadAndStoreLocalData,
        completionHandler handler: (Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void) -> Void {
            
            switch offlinePolicy {
            case .None:
                getInstancesNoCache(moduleId, completionHandler: handler)
            case .LoadAndStoreLocalData:
                getInstancesLoadAndStoreLocalData(moduleId, completionHandler: handler)
            case .ReturnLocalDataElseLoad:
                getInstancesReturnLocalDataElseLoad(moduleId, completionHandler: handler)
            case .ReturnLocalDataDontLoad:
                getInstancesReturnLocalDataDontLoad(moduleId, completionHandler: handler)
            }
    }

    private func getInstancesNoCache(moduleId: String,
        completionHandler handler: (Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void) -> Void {
            
            net.generalContentInstances(moduleId, flags: [], completionHandler: handler)
    }
    
    private func getInstancesLoadAndStoreLocalData(moduleId: String,
        completionHandler handler: (Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void) -> Void {
            
            net.generalContentInstances(moduleId, flags: []) { (result) -> Void in
                switch result {
                case .Success(let instances):
                    handler(.Success(instances))
                    
                    try! self.realm.write({ () -> Void in
                        
                        self.realm.delete(self.realm.objects(PersistentGeneralContentInstance).filter("moduleId = '\(moduleId)'"))
                        
                        for instance in instances {
                            self.realm.add(PersistentGeneralContentInstance(instance), update: true)
                        }
                    })
                case .Failure(let error):
                    if error.code == -1009 {
                        self.getInstancesReturnLocalDataDontLoad(moduleId, completionHandler: handler)
                    } else {
                        handler(.Failure(error))
                    }
                }
            }
    }
    
    private func getInstancesReturnLocalDataElseLoad(moduleId: String,
        completionHandler handler: (Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void) -> Void {
            
        self.getInstancesReturnLocalDataDontLoad(moduleId) { (result) -> Void in
            switch result {
            case .Success(let instances):
                if instances.count > 0 {
                    handler(.Success(instances))
                } else {
                    self.getInstancesLoadAndStoreLocalData(moduleId, completionHandler: handler)
                }
            case .Failure(let error):
                handler(.Failure(error))
            }
        }
            
    }
    
    private func getInstancesReturnLocalDataDontLoad(moduleId: String,
        completionHandler handler: (Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void) -> Void {
            
            let instances = realm.objects(PersistentGeneralContentInstance).filter("moduleId = '\(moduleId)'")
            
            let result = instances.map { (persistentInstance) -> Halo.GeneralContentInstance in
                return persistentInstance.getInstance()
            }
            
            handler(.Success(result))
    }
    
    // MARK: Get instances by array of ids
    
    /**
     Get a set of general content instances by specifying their ids
     
     - parameter instanceIds: Ids of the instances to be retrieved
     - parameter handler:     Closure to be executed after the completion of the request
     */
    public func getInstances(instanceIds instanceIds: [String], offlinePolicy: OfflinePolicy = .LoadAndStoreLocalData,
        completionHandler handler: ((Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
           
            switch offlinePolicy {
            case .None:
                getInstancesNoCache(instanceIds, completionHandler: handler)
            case .LoadAndStoreLocalData:
                getInstancesLoadAndStoreLocalData(instanceIds, completionHandler: handler)
            case .ReturnLocalDataElseLoad:
                getInstancesReturnLocalDataElseLoad(instanceIds, completionHandler: handler)
            case .ReturnLocalDataDontLoad:
                getInstancesReturnLocalDataDontLoad(instanceIds, completionHandler: handler)
            }
    }
    
    private func getInstancesNoCache(instanceIds: [String],
        completionHandler handler: ((Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
        
            net.generalContentInstances(instanceIds, completionHandler: handler)
    }
    
    private func getInstancesLoadAndStoreLocalData(instanceIds: [String],
        completionHandler handler: ((Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
        
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
                        self.getInstancesReturnLocalDataDontLoad(instanceIds, completionHandler: handler)
                    } else {
                        handler?(.Failure(error))
                    }
                }
            }
    }
    
    private func getInstancesReturnLocalDataElseLoad(instanceIds: [String],
        completionHandler handler: ((Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
     
            self.getInstancesReturnLocalDataDontLoad(instanceIds) { (result) -> Void in
                switch result {
                case .Success(let instances):
                    if instances.count > 0 {
                        handler?(.Success(instances))
                    } else {
                        self.getInstancesLoadAndStoreLocalData(instanceIds, completionHandler: handler)
                    }
                case .Failure(let error):
                    handler?(.Failure(error))
                }
            }
    }
    
    private func getInstancesReturnLocalDataDontLoad(instanceIds: [String],
        completionHandler handler: ((Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
            
            let instances = realm.objects(PersistentGeneralContentInstance).filter("id IN \(instanceIds)")
            
            let result = instances.map { (persistentInstance) -> Halo.GeneralContentInstance in
                return persistentInstance.getInstance()
            }
            
            handler?(.Success(result))
    }
    
    // MARK: Get a single instance
    
    /**
    Get a specific general content instance by id

    - parameter instanceId: Id of the instance to be retrieved
    - parameter handler:    Closure to be executed after the completion of the request
    */
    public func getInstance(instanceId instanceId: String, offlinePolicy: OfflinePolicy = .LoadAndStoreLocalData,
        completionHandler handler: ((Alamofire.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
        
            switch offlinePolicy {
            case .None:
                getInstanceNoCache(instanceId, completionHandler: handler)
            case .LoadAndStoreLocalData:
                getInstanceLoadAndStoreLocalData(instanceId, completionHandler: handler)
            case .ReturnLocalDataElseLoad:
                getInstanceReturnLocalDataElseLoad(instanceId, completionHandler: handler)
            case .ReturnLocalDataDontLoad:
                getInstanceReturnLocalDataDontLoad(instanceId, completionHandler: handler)
            }
    }
    
    private func getInstanceNoCache(instanceId: String,
        completionHandler handler: ((Alamofire.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
            net.generalContentInstance(instanceId, completionHandler: handler)
    }
    
    
    private func getInstanceLoadAndStoreLocalData(instanceId: String,
        completionHandler handler: ((Alamofire.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
            
            net.generalContentInstance(instanceId) { (result) -> Void in
                switch result {
                case .Success(let instance):
                    handler?(.Success(instance))
                    
                    try! self.realm.write({ () -> Void in
                        self.realm.add(PersistentGeneralContentInstance(instance), update: true)
                    })
                    
                case .Failure(let error):
                    if error.code == -1009 {
                        self.getInstanceReturnLocalDataDontLoad(instanceId, completionHandler: handler)
                    } else {
                        handler?(.Failure(error))
                    }
                }
            }
            
    }
    
    private func getInstanceReturnLocalDataElseLoad(instanceId: String,
        completionHandler handler: ((Alamofire.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
            
            self.getInstanceReturnLocalDataDontLoad(instanceId) { (result) -> Void in
                switch result {
                case .Success(let instance):
                    handler?(.Success(instance))
                case .Failure(let error):
                    if error.domain == "com.mobgen" {
                        self.getInstanceLoadAndStoreLocalData(instanceId, completionHandler: handler)
                    } else {
                        handler?(.Failure(error))
                    }
                }
            }
    }
    
    private func getInstanceReturnLocalDataDontLoad(instanceId: String,
        completionHandler handler: ((Alamofire.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
            
            if let instance = realm.objectForPrimaryKey(PersistentGeneralContentInstance.self, key: instanceId) {
                handler?(.Success(instance.getInstance()))
            } else {
                handler?(.Failure(NSError(domain: "com.mobgen", code: 0, userInfo: nil)))
            }
    }

}