//
//  GeneralContent.swift
//  HaloSDK
//
//  Created by Borja on 31/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import RealmSwift

/**
 Access point to the General Content. This class will provide methods to obtain the data stored as general content.
 */
@objc(HaloGeneralContent)
public class GeneralContent: NSObject {

    /// Shortcut for the shared instance of the network manager
    private let net = Halo.NetworkManager.instance

    private let persistence = Halo.PersistenceManager.sharedInstance
    
    /// Shared instance of the General Content component (Singleton pattern)
    public static let sharedInstance = GeneralContent()

    private override init() {}
    
    // MARK: Get instances
    
    /**
    Get the existing instances of a given General Content module

    - parameter moduleIds:          Internal ids of the modules from which we want to retrieve the instances
    - parameter offlinePolicy:      Offline policy to be considered when retrieving data
    - parameter completionHandler:  Closure to be executed when the request has finished
    */
    public func getInstances(moduleIds moduleIds: [String],
        var offlinePolicy: OfflinePolicy? = nil,
        populate: Bool? = false,
        flags: GeneralContentFlag? = [],
        completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
            
            offlinePolicy = offlinePolicy ?? Manager.sharedInstance.defaultOfflinePolicy
            
            switch offlinePolicy! {
            case .None:
                net.generalContentInstances(moduleIds: moduleIds, flags: flags, populate: populate, completionHandler: handler)
            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
                persistence.generalContentInstances(moduleIds: moduleIds, flags: flags, fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), populate: populate, completionHandler: handler)
            }
    }

    // MARK: Get instances by array of ids
    
    /**
     Get a set of general content instances by specifying their ids
     
     - parameter instanceIds:   Ids of the instances to be retrieved
     - parameter offlinePolicy: Offline policy to be considered when retrieving data
     - parameter handler:       Closure to be executed after the completion of the request
     */
    public func getInstances(instanceIds instanceIds: [String],
        offlinePolicy: OfflinePolicy? = Manager.sharedInstance.defaultOfflinePolicy,
        flags: GeneralContentFlag? = [],
        completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
           
            switch offlinePolicy! {
            case .None:
                self.net.generalContentInstances(instanceIds: instanceIds, flags: flags, completionHandler: handler)
            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
                self.persistence.generalContentInstances(instanceIds: instanceIds, fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: handler)
            }
    }
    
    // MARK: Get a single instance
    
    /**
    Get a specific general content instance by id

    - parameter instanceId:     Id of the instance to be retrieved
    - parameter offlinePolicy:  Offline policy to be considered when retrieving data
    - parameter handler:        Closure to be executed after the completion of the request
    */
    public func getSingleInstance(instanceId instanceId: String,
        offlinePolicy: OfflinePolicy? = Manager.sharedInstance.defaultOfflinePolicy,
        completionHandler handler: ((Halo.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
        
            switch offlinePolicy! {
            case .None:
                self.net.generalContentInstance(instanceId, completionHandler: handler)
            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
                self.persistence.generalContentInstance(instanceId, fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: handler)
            }
    }

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
        success:((instances: [GeneralContentInstance], cached: Bool) -> Void)?,
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
        success:((instances: [GeneralContentInstance], cached: Bool) -> Void)?,
        failure: ((error: NSError) -> Void)?) -> Void {

            self.getInstances(moduleIds: moduleIds, offlinePolicy: offlinePolicy) { (result) -> Void in
                switch result {
                case .Success(let data, let cached):
                    success?(instances: data, cached: cached)
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
        success:((instances: [GeneralContentInstance], cached: Bool) -> Void)?,
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
        success:((instances: [GeneralContentInstance], cached: Bool) -> Void)?,
        failure: ((error: NSError) -> Void)?) -> Void {

            self.privateGetInstancesFromObjC(moduleIds: instanceIds, offlinePolicy: nil, success: success, failure: failure)
    }

    private func privateGetInstancesFromObjC(instanceIds instanceIds: [String], offlinePolicy: OfflinePolicy?,
        success:((instances: [GeneralContentInstance], cached: Bool) -> Void)?,
        failure: ((error: NSError) -> Void)?) -> Void {

            self.getInstances(moduleIds: instanceIds, offlinePolicy: offlinePolicy) { (result) -> Void in
                switch result {
                case .Success(let data, let cached):
                    success?(instances: data, cached: cached)
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

            self.getSingleInstance(instanceId: instanceId, offlinePolicy: offlinePolicy) { (result) -> Void in
                switch result {
                case .Success(let instance, let cached):
                    success?(userData: instance, cached: cached)
                case .Failure(let error):
                    failure?(error: error)
                }
            }
    }

}