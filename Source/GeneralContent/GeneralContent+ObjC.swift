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
    
    - parameter moduleId:   Internal id of the module from which we want to retrieve the instances
    - parameter success:    Closure to be executed when the request has succeeded
    - parameter failure:    Closure to be executed when the request has failed
    */
    @objc(instancesInModule:offlinePolicy:success:failure:)
    public func getInstancesFromObjC(moduleId moduleId: String, offlinePolicy: OfflinePolicy,
        success:((userData: [GeneralContentInstance], cached: Bool) -> Void)?,
        failure: ((error: NSError) -> Void)?) -> Void {
            
            self.getInstances(moduleId: moduleId, offlinePolicy: offlinePolicy) { (result, cached) -> Void in
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
     
     - parameter instancesWithIds: Array of instance ids
     */
    @objc(instancesWithIds:offlinePolicy:success:failure:)
    public func getInstancesFromObjC(instanceIds instanceIds: [String], offlinePolicy: OfflinePolicy,
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
     
     - parameter instanceId: Internal id of the instance to be retrieved
     - parameter success:    Closure to be executed when the request has succeeded
     - parameter failure:    Closure to be executed when the request has failed
     */
    @objc(instance:offlinePolicy:success:failure:)
    public func getInstanceFromObjC(instanceId instanceId: String, offlinePolicy: OfflinePolicy,
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