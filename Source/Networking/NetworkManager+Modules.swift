//
//  NetworkManager+Modules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 05/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

extension NetworkManager {

    /**
    Get the list of available modules for a given client id/client secret pair

    - parameter completionHandler:  Closure to be executed once the request has finished
    */
    func getModules(page page: Int? = nil, limit: Int? = nil) -> Halo.Request<[Halo.Module]> {

        let req = Halo.Request<[Halo.Module]>(router: Router.Modules)
        
        req.responseParser { data in
            switch data {
            case let d as [[String : AnyObject]]:
                return self.parseModules(d)
            case let d as [String: AnyObject]:
                return self.parseModules(d["items"] as! [[String: AnyObject]])
            default:
                return []
            }
        }

        return req

    }
    
    // MARK: Utility functions

    /**
    Parse a list of dictionaries (from the JSON response) into a list of modules

    - parameter modules:     List of dictionaries coming from the JSON response

    - returns   The list of the parsed modules
    */
    private func parseModules(modules: [[String : AnyObject]]) -> [Halo.Module] {
        return modules.map({ Module($0) })
    }
}