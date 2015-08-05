//
//  NetworkManager+Modules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 05/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

extension NetworkManager {

    /**
    Get the list of available modules for a given client id/client secret pair

    - parameter completionHandler:  Closure to be executed once the request has finished
    */
    func getModules(completionHandler handler: (Alamofire.Result<[Halo.Module]>) -> Void) -> Void {

        self.startRequest(Router.Modules, completionHandler: { [weak self] (req, resp, result) -> Void in
            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    let arr = strongSelf.parseModules(data as! [Dictionary<String,AnyObject>])
                    handler(.Success(arr))
                case .Failure(let data, let error):
                    handler(.Failure(data, error))
                }
            }
        })
    }

    // MARK: Utility functions

    /**
    Parse a list of dictionaries (from the JSON response) into a list of modules

    - parameter modules:     List of dictionaries coming from the JSON response

    - returns   The list of the parsed modules
    */
    private func parseModules(modules: [Dictionary<String,AnyObject>]) -> [Halo.Module] {

        var modArray: [Halo.Module] = []

        for dict in modules {
            modArray.append(Module(dict))
        }
        
        return modArray
    }
}