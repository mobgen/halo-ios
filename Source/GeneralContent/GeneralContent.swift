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
public struct GeneralContentManager: HaloManager {

    init() {}

    func startup(completionHandler handler: (Bool) -> Void) {

    }

    // MARK: Get instances
    
    /**
    Get the existing instances of a given General Content module

    - parameter moduleIds:          Internal ids of the modules from which we want to retrieve the instances
    - parameter offlinePolicy:      Offline policy to be considered when retrieving data
    - parameter completionHandler:  Closure to be executed when the request has finished
    */
    public func getInstances(moduleIds moduleIds: [String],
        var offlinePolicy: OfflinePolicy? = nil,
        populate: Bool = false,
        flags: GeneralContentFlag = [],
        completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {

            offlinePolicy = offlinePolicy ?? Manager.core.defaultOfflinePolicy
            
            switch offlinePolicy! {
            case .None:
                Manager.network.generalContentInstances(moduleIds: moduleIds, flags: flags).response(completionHandler: { (result) -> Void in
                    switch result {
                    case .Success(let data as [[String : AnyObject]], let cached):
                        let instances = data.map({ Halo.GeneralContentInstance($0) })
                        handler?(.Success(instances, cached))
                    case .Failure(let error):
                        handler?(.Failure(error))
                    default:
                        break
                    }
                })
            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
                Manager.persistence.generalContentInstances(moduleIds: moduleIds, flags: flags, fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), populate: populate, completionHandler: handler)
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
        offlinePolicy: OfflinePolicy? = Manager.core.defaultOfflinePolicy,
        flags: GeneralContentFlag? = [],
        completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
           
//            switch offlinePolicy! {
//            case .None:
//                self.net.generalContentInstances(instanceIds: instanceIds, flags: flags, completionHandler: handler)
//            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
//                self.persistence.generalContentInstances(instanceIds: instanceIds, fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: handler)
//            }
    }
    
    // MARK: Get a single instance
    
    /**
    Get a specific general content instance by id

    - parameter instanceId:     Id of the instance to be retrieved
    - parameter offlinePolicy:  Offline policy to be considered when retrieving data
    - parameter handler:        Closure to be executed after the completion of the request
    */
    public func getSingleInstance(instanceId instanceId: String,
        offlinePolicy: OfflinePolicy? = Manager.core.defaultOfflinePolicy,
        completionHandler handler: ((Halo.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
        
//            switch offlinePolicy! {
//            case .None:
//                self.net.generalContentInstance(instanceId, completionHandler: handler)
//            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
//                self.persistence.generalContentInstance(instanceId, fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: handler)
//            }
    }

}