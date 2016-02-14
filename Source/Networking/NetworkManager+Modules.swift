//
//  NetworkManager+Modules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 05/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

extension NetworkManager: ModulesManager {

    /**
    Get the list of available modules for a given client id/client secret pair

    - parameter completionHandler:  Closure to be executed once the request has finished
    */
    func getModules() -> Halo.Request<[Halo.Module]> { //fetchFromNetwork network: Bool = true, completionHandler handler: ((Halo.Result<[Halo.Module], NSError>) -> Void)? = nil) -> Void {

        return Halo.Request<[Halo.Module]>(router: Router.Modules)

//        self.startRequest(request: Router.Modules, completionHandler: { [weak self] (request, response, result) in
//
//            if let strongSelf = self {
//                switch result {
//                case .Success(let data, let cached):
//                    let arr = strongSelf.parseModules(data as! [Dictionary<String,AnyObject>])
//                    handler?(.Success(arr, cached))
//                case .Failure(let error):
//                    handler?(.Failure(error))
//                }
//            }
//        })
    }

    // MARK: Utility functions

    /**
    Parse a list of dictionaries (from the JSON response) into a list of modules

    - parameter modules:     List of dictionaries coming from the JSON response

    - returns   The list of the parsed modules
    */
    private func parseModules(modules: [Dictionary<String,AnyObject>]) -> [Halo.Module] {
        return modules.map({ Module($0) })
    }
}