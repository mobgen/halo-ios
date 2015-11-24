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

    private let persistence = Halo.PersistenceManager.sharedInstance
    
    /// Shared instance of the General Content component (Singleton pattern)
    public static let sharedInstance = GeneralContent()

    private override init() {}
    
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
                net.generalContentInstances(moduleId, flags: [], completionHandler: handler)
            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
                persistence.generalContentInstances(moduleId, flags: [], fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: handler)
            }
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
                self.net.generalContentInstances(instanceIds, fetchFromNetwork: true, completionHandler: handler)
            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
                self.persistence.generalContentInstances(instanceIds, fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: handler)
            }
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
                self.net.generalContentInstance(instanceId, fetchFromNetwork: true, completionHandler: handler)
            case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
                self.persistence.generalContentInstance(instanceId, fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: handler)
            }
    }

}