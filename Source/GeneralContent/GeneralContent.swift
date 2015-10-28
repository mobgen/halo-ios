//
//  GeneralContent.swift
//  HaloSDK
//
//  Created by Borja on 31/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire


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

    /**
    Get the existing instances of a given General Content module

    - parameter moduleId:           Internal id of the module from which we want to retrieve the instances
    - parameter completionHandler:  Closure to be executed when the request has finished
    */
    public func getInstances(moduleId moduleId: String,
        completionHandler handler: (Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void) -> Void {
            net.generalContentInstances(moduleId, flags: [], completionHandler: handler)
    }

    /**
    Get a specific general content instance by id

    - parameter instanceId: Id of the instance to be retrieved
    - parameter handler:    Closure to be executed after the completion of the request
    */
    public func getInstance(instanceId instanceId: String,
        completionHandler handler: (Alamofire.Result<Halo.GeneralContentInstance, NSError>) -> Void) -> Void {
        net.generalContentInstance(instanceId, completionHandler: handler)
    }
        
    /**
    Get a set of general content instances by specifying their ids
     
     - parameter instanceIds: Ids of the instances to be retrieved
     - parameter handler:     Closure to be executed after the completion of the request
     */
    public func getInstances(instanceIds instanceIds: [String],
        completionHandler handler: (Alamofire.Result<[Halo.GeneralContentInstance], NSError>) -> Void) -> Void {
        net.generalContentInstances(instanceIds, completionHandler: handler)
    }
    
    // MARK: ObjC exposed methods

    /**
    Get the existing instances of a given General Content module from Objective C

    - parameter moduleId:   Internal id of the module from which we want to retrieve the instances
    - parameter success:    Closure to be executed when the request has succeeded
    - parameter failure:    Closure to be executed when the request has failed
    */
    @objc(instancesInModule:success:failure:)
    public func getInstancesFromObjC(moduleId moduleId: String,
        success:((userData: [GeneralContentInstance]) -> Void)?,
        failure: ((error: NSError) -> Void)?) -> Void {

            self.getInstances(moduleId: moduleId) { (result) -> Void in
                switch result {
                case .Success(let instances):
                    success?(userData: instances)
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
    @objc(instance:success:failure:)
    public func getInstanceFromObjC(instanceId instanceId: String,
        success:((userData: GeneralContentInstance) -> Void)?,
        failure:((error: NSError) -> Void)?) -> Void {

            self.getInstance(instanceId: instanceId) { (result) -> Void in
                switch result {
                case .Success(let instance):
                    success?(userData: instance)
                case .Failure(let error):
                    failure?(error: error)
                }
            }

    }

}