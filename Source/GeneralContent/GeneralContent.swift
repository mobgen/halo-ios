//
//  GeneralContent.swift
//  HaloSDK
//
//  Created by Borja on 31/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

public class GeneralContent: NSObject {

    /// Shortcut for the shared instance of the network manager
    private let net = Halo.NetworkManager.instance

    /// Shared instance of the General Content component (Singleton pattern)
    public static let sharedInstance = GeneralContent()

    private override init() {}

    /**
    Get the existing instances of a given General Content module

    - parameter moduleId:   Internal id of the module from which we want to retrieve the instances
    - parameter success:    Closure to be executed when the request has succeeded
    - parameter failure:    Closure to be executed when the request has failed
    */
    public func generalContentInstances(moduleId: String,
        success:((userData: [GeneralContentInstance]) -> Void)?,
        failure: ((error: NSError) -> Void)?) -> Void {

            net.generalContentModule(moduleId) { (result) -> Void in
                switch result {
                case .Success(let instances):
                    success?(userData: instances)
                case .Failure(_, let error):
                    failure?(error: error)
                }
            }
    }

}