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
    public func getInstances(moduleIds moduleIds: [String], offlinePolicy: OfflinePolicy? = Manager.sharedInstance.defaultOfflinePolicy, populate: Bool? = false,
        completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
            
            switch offlinePolicy! {
            case .None:
                net.generalContentInstances(moduleIds, flags: [], populate: populate, completionHandler: handler)
            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
                persistence.generalContentInstances(moduleIds, flags: [], fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), populate: populate, completionHandler: handler)
            }
    }

    // MARK: Get instances by array of ids
    
    /**
     Get a set of general content instances by specifying their ids
     
     - parameter instanceIds:   Ids of the instances to be retrieved
     - parameter offlinePolicy: Offline policy to be considered when retrieving data
     - parameter handler:       Closure to be executed after the completion of the request
     */
    public func getInstances(instanceIds instanceIds: [String], offlinePolicy: OfflinePolicy? = Manager.sharedInstance.defaultOfflinePolicy,
        completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void {
           
            switch offlinePolicy! {
            case .None:
                self.net.generalContentInstances(instanceIds, fetchFromNetwork: true, completionHandler: handler)
            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
                self.persistence.generalContentInstances(instanceIds, fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: { (result) -> Void in
                    handler?(result)
                })
            }
    }
    
    // MARK: Get a single instance
    
    /**
    Get a specific general content instance by id

    - parameter instanceId:     Id of the instance to be retrieved
    - parameter offlinePolicy:  Offline policy to be considered when retrieving data
    - parameter handler:        Closure to be executed after the completion of the request
    */
    public func getSingleInstance(instanceId instanceId: String, offlinePolicy: OfflinePolicy? = Manager.sharedInstance.defaultOfflinePolicy,
        completionHandler handler: ((Halo.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void {
        
            switch offlinePolicy! {
            case .None:
                self.net.generalContentInstance(instanceId, fetchFromNetwork: true, completionHandler: handler)
            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
                self.persistence.generalContentInstance(instanceId, fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: handler)
            }
    }

}