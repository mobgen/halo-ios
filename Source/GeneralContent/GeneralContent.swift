//
//  GeneralContent.swift
//  HaloSDK
//
//  Created by Borja on 31/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

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
    public func getInstances(moduleId: String,
        completionHandler handler: (Alamofire.Result<[Halo.GeneralContentInstance]>) -> Void) -> Void {
            net.generalContentInstances(moduleId, completionHandler: handler)
    }

    // MARK: ObjC exposed methods

    /**
    Get the existing instances of a given General Content module from Objective C

    - parameter moduleId:   Internal id of the module from which we want to retrieve the instances
    - parameter success:    Closure to be executed when the request has succeeded
    - parameter failure:    Closure to be executed when the request has failed
    */

    @objc(instances:success:failure:)
    public func getInstancesFromObjC(moduleId: String,
        success:((userData: [GeneralContentInstance]) -> Void)?,
        failure: ((error: NSError) -> Void)?) -> Void {

            self.getInstances(moduleId) { (result) -> Void in
                switch result {
                case .Success(let instances):
                    success?(userData: instances)
                case .Failure(_, let error):
                    failure?(error: error)
                }
            }
    }

}