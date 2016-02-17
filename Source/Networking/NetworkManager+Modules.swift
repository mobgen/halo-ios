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
    func getModules(page page: Int? = nil, limit: Int? = nil, completionHandler handler: ((Halo.Result<[Halo.Module], NSError>) -> Void)? = nil) -> Void {

        let req = Halo.Request(router: Router.Modules)
        
        if let p = page, l = limit {
            req.paginate(page: p, limit: l)
        }
        
        req.response { result in
            switch result {
            case .Success(let data as [[String: AnyObject]], let cached):
                let modules = self.parseModules(data)
                handler?(.Success(modules, cached))
            case .Success(let data as [String: AnyObject], let cached):
                // Paginated response
                let modules = self.parseModules(data["items"] as! [[String: AnyObject]])
                handler?(.Success(modules, cached))
            case .Failure(let error):
                handler?(.Failure(error))
            default:
                handler?(.Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
            }
        }
        
    }
    
    // MARK: Utility functions

    /**
    Parse a list of dictionaries (from the JSON response) into a list of modules

    - parameter modules:     List of dictionaries coming from the JSON response

    - returns   The list of the parsed modules
    */
    private func parseModules(modules: [[String:AnyObject]]) -> [Halo.Module] {
        return modules.map({ Module($0) })
    }
}