//
//  GeneralContent+ObjC.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 16/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

extension GeneralContent {
 
    // MARK: ObjC exposed methods
    
    /**
    Get the existing instances of a given General Content module from Objective C
    
    - parameter moduleIds:      Internal ids of the modules from which we want to retrieve the instances
    - parameter offlinePolicy:  Offline policy to be considered when retrieving data
    - parameter success:        Closure to be executed when the request has succeeded
    - parameter failure:        Closure to be executed when the request has failed
    */
    @objc(instancesInModules:offlinePolicy:success:failure:)
    public func getInstancesWithOfflinePolicyFromObjC(moduleIds moduleIds: [String], offlinePolicy: OfflinePolicy,
        success:((userData: [GeneralContentInstance], cached: Bool) -> Void)?,
        failure: ((error: NSError) -> Void)?) -> Void {
            
            self.privateGetInstancesFromObjC(moduleIds: moduleIds, offlinePolicy: offlinePolicy, success: success, failure: failure)
    }
    
    /**
     Get the existing instances of a given General Content module from Objective C
     
     - parameter moduleId:   Internal id of the module from which we want to retrieve the instances
     - parameter success:    Closure to be executed when the request has succeeded
     - parameter failure:    Closure to be executed when the request has failed
     */
    @objc(instancesInModules:success:failure:)
    public func getInstancesFromObjC(moduleIds moduleIds: [String],
        success:((userData: [GeneralContentInstance], cached: Bool) -> Void)?,
        failure: ((error: NSError) -> Void)?) -> Void {
            
            self.privateGetInstancesFromObjC(moduleIds: moduleIds, offlinePolicy: nil, success: success, failure: failure)
    }
    
    
    private func privateGetInstancesFromObjC(moduleIds moduleIds: [String], offlinePolicy: OfflinePolicy?,
        success:((userData: [GeneralContentInstance], cached: Bool) -> Void)?,
        failure: ((error: NSError) -> Void)?) -> Void {
            
            self.getInstances(moduleIds: moduleIds, offlinePolicy: offlinePolicy) { (result, cached) -> Void in
                switch result {
                case .Success(let instances):
                    success?(userData: instances, cached: cached)
                case .Failure(let error):
                    failure?(error: error)
                }
            }
    }
    
    /**
     Get a set of instances given the collection of their ids from Objective C
     
     - parameter instancesIds:  Array of instance ids
     - parameter offlinePolicy: Offline policy to be considered when retrieving data
     - parameter success:       Closure to be executed when the request has succeeded
     - parameter failure:       Closure to be executed when the request has failed
     */
    @objc(instancesWithIds:offlinePolicy:success:failure:)
    public func getInstancesWithOfflinePolicyFromObjC(instanceIds instanceIds: [String], offlinePolicy: OfflinePolicy,
        success:((userData: [GeneralContentInstance], cached: Bool) -> Void)?,
        failure: ((error: NSError) -> Void)?) -> Void {
            
            self.privateGetInstancesFromObjC(moduleIds: instanceIds, offlinePolicy: offlinePolicy, success: success, failure: failure)
    }
    
    /**
     Get a set of instances given the collection of their ids from Objective C
     
     - parameter instancesIds:  Array of instance ids
     - parameter offlinePolicy: Offline policy to be considered when retrieving data
     - parameter success:       Closure to be executed when the request has succeeded
     - parameter failure:       Closure to be executed when the request has failed
     */
    @objc(instancesWithIds:success:failure:)
    public func getInstancesFromObjC(instanceIds instanceIds: [String],
        success:((userData: [GeneralContentInstance], cached: Bool) -> Void)?,
        failure: ((error: NSError) -> Void)?) -> Void {
            
            self.privateGetInstancesFromObjC(moduleIds: instanceIds, offlinePolicy: nil, success: success, failure: failure)
    }
    
    private func privateGetInstancesFromObjC(instanceIds instanceIds: [String], offlinePolicy: OfflinePolicy?,
        success:((userData: [GeneralContentInstance], cached: Bool) -> Void)?,
        failure: ((error: NSError) -> Void)?) -> Void {
     
            self.getInstances(instanceIds: instanceIds, offlinePolicy: offlinePolicy) { (result, cached) -> Void in
                switch result {
                case .Success(let instances):
                    success?(userData: instances, cached: cached)
                case .Failure(let error):
                    failure?(error: error)
                }
            }
    }
    
    /**
     Get a specific general content instance given its id from Objective C
     
     - parameter instanceId:    Internal id of the instance to be retrieved
     - parameter offlinePolicy: Offline policy to be considered when retrieving data
     - parameter success:       Closure to be executed when the request has succeeded
     - parameter failure:       Closure to be executed when the request has failed
     */
    @objc(instance:offlinePolicy:success:failure:)
    public func getInstanceWithOfflinePolicyFromObjC(instanceId instanceId: String, offlinePolicy: OfflinePolicy,
        success:((userData: GeneralContentInstance, cached: Bool) -> Void)?,
        failure:((error: NSError) -> Void)?) -> Void {
            
            self.privateGetInstanceFromObjc(instanceId: instanceId, offlinePolicy: offlinePolicy, success: success, failure: failure)
    
    }
    
    /**
     Get a specific general content instance given its id from Objective C
     
     - parameter instanceId:    Internal id of the instance to be retrieved
     - parameter offlinePolicy: Offline policy to be considered when retrieving data
     - parameter success:       Closure to be executed when the request has succeeded
     - parameter failure:       Closure to be executed when the request has failed
     */
    @objc(instance:success:failure:)
    public func getInstanceFromObjC(instanceId instanceId: String,
        success:((userData: GeneralContentInstance, cached: Bool) -> Void)?,
        failure:((error: NSError) -> Void)?) -> Void {
            
            self.privateGetInstanceFromObjc(instanceId: instanceId, offlinePolicy: nil, success: success, failure: failure)
    
    }
    
    private func privateGetInstanceFromObjc(instanceId instanceId: String, offlinePolicy: OfflinePolicy?,
        success:((userData: GeneralContentInstance, cached: Bool) -> Void)?,
        failure:((error: NSError) -> Void)?) -> Void {
     
            self.getInstance(instanceId: instanceId, offlinePolicy: offlinePolicy) { (result, cached) -> Void in
                switch result {
                case .Success(let instance):
                    success?(userData: instance, cached: cached)
                case .Failure(let error):
                    failure?(error: error)
                }
            }
    }
    
}