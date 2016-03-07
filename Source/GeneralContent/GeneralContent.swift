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

    func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {

    }

    // MARK: Get instances
    
    /**
    Get the existing instances of a given General Content module

    - parameter moduleIds:          Internal ids of the modules from which we want to retrieve the instances
    - parameter offlinePolicy:      Offline policy to be considered when retrieving data
    - parameter completionHandler:  Closure to be executed when the request has finished
    */
    public func getInstances(moduleIds moduleIds: [String],
        offlinePolicy: OfflinePolicy? = nil,
        populate: Bool = false,
        flags: GeneralContentFlag = [],
        completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {

            let offline = offlinePolicy ?? Manager.core.defaultOfflinePolicy
            
            switch offline {
            case .None:
                let request = Manager.network.generalContentInstances(moduleIds: moduleIds, flags: flags)
                
                request.response(completionHandler: { (result) -> Void in
                    switch result {
                    case .Success(let data as [String : AnyObject], let cached):
                        let items = data["items"] as! [[String : AnyObject]]
                        handler?(.Success(items.map({ GeneralContentInstance($0) }), cached))
                    case .Success(let data as [[String : AnyObject]], let cached):
                        handler?(.Success(data.map({ GeneralContentInstance($0) }), cached))
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
           
            switch offlinePolicy! {
            case .None:
                let request = Manager.network.generalContentInstances(instanceIds: instanceIds, flags: flags)
                
                request.response(completionHandler: { (result) -> Void in
                    switch result {
                    case .Success(let data as [String : AnyObject], let cached):
                        let items = data["items"] as! [[String : AnyObject]]
                        handler?(.Success(items.map({ GeneralContentInstance($0) }), cached))
                    case .Success(let data as [[String : AnyObject]], let cached):
                        handler?(.Success(data.map({ GeneralContentInstance($0) }), cached))
                    case .Failure(let error):
                        handler?(.Failure(error))
                    default:
                        break
                    }
                })
                
            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
                Manager.persistence.generalContentInstances(instanceIds: instanceIds, fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: handler)
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
        offlinePolicy: OfflinePolicy? = Manager.core.defaultOfflinePolicy,
        completionHandler handler: ((Halo.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
        
            switch offlinePolicy! {
            case .None:
                let request = Manager.network.generalContentInstance(instanceId)
                
                request.response(completionHandler: { (result) -> Void in
                    switch result {
                    case .Success(let data as [String : AnyObject], let cached):
                        handler?(.Success(GeneralContentInstance(data), cached))
                    case .Failure(let error):
                        handler?(.Failure(error))
                    default:
                        break
                    }
                })
            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
                Manager.persistence.generalContentInstance(instanceId, fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: handler)
            }
    }

}