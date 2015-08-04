//
//  Networking.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

/// Module encapsulating all the networking features of the Framework
class Networking {

    private let net = HaloNetworkManager.instance

    /// Singleton instance of the networking component
    static let sharedInstance = Halo.Networking()

    /// Client id to be used for authentication throughout the SDK
    var clientId: String? {
        set {
            net.clientId = newValue
        }
        get {
            return net.clientId
        }
    }

    /// Client secret to be used for authentication throughout the SDK
    var clientSecret: String? {
        set {
            net.clientSecret = newValue
        }
        get {
            return net.clientSecret
        }
    }

    /**
    Get the list of available modules for a given client id/client secret pair

    - parameter completionHandler:  Closure to be executed once the request has finished
    */
    func getModules(completionHandler handler: (result: Alamofire.Result<[Halo.HaloModule]>) -> Void) -> Void {
        
        net.startRequest(Router.Modules, completionHandler: { [weak self] (req, resp, result) -> Void in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    let arr = strongSelf.parseModules(data as! [Dictionary<String,AnyObject>])
                    handler(result: .Success(arr))
                case .Failure(let data, let error):
                    handler(result: .Failure(data, error))
                }
            }
        })
    }

    func getModuleInstances(internalId id: String, completionHandler handler: (Alamofire.Result<[Dictionary<String, AnyObject>]>) -> Void) -> Void {
        
    }

    // MARK: Utility functions

    /**
    Parse a list of dictionaries (from the JSON response) into a list of modules
    
    - parameter modules:     List of dictionaries coming from the JSON response
    
    - returns   The list of the parsed modules
    */
    private func parseModules(modules: [Dictionary<String,AnyObject>]) -> [HaloModule] {

        var modArray = [HaloModule]()

        for dict in modules {
            modArray.append(HaloModule(dict: dict))
        }

        return modArray
    }
}
