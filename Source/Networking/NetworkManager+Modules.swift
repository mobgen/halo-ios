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
    func getModules() -> Halo.Request {

        let req = Halo.Request(router: Router.Modules)
        
//        req.responseParser { (obj) -> [Module] in
//            switch obj {
//            case let d as [[String:AnyObject]]:
//                return self.parseModules(d)
//            case let d as [String:AnyObject]:
//                let items = d["items"] as! [[String : AnyObject]]
//                return self.parseModules(items)
//            default:
//                return []
//            }
//        }
        
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