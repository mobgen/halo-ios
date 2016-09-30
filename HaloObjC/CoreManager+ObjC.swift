//
//  HaloCoreManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Halo

extension CoreManager {

    public var env: String {
        return self.environment.description
    }
    
    @objc(modulesWithSuccess:failure:)
    public func modules(success: (NSHTTPURLResponse?, PaginatedModules) -> Void,
                        failure: (NSHTTPURLResponse?, NSError) -> Void) -> Void {

        self.getModules { (response, result) in

            switch result {
            case .Success(let data, _):
                if let modules = data {
                    success(response, modules)
                }
            case .Failure(let error):
                failure(response, error)
            }
        }
    }
    
    @objc(setEnvironment:withCompletionHandler:)
    public func setEnvironment(environment env: String, completionHandler handler: ((Bool) -> Void)? = nil) -> Void {
        
        var envir: HaloEnvironment!
        
        switch env.lowercaseString {
        case "int":
            envir = .Int
        case "prod":
            envir = .Prod
        case "stage":
            envir = .Stage
        case "qa":
            envir = .QA
        default:
            envir = .Custom(env)
        }
        
        self.setEnvironment(environment: envir, completionHandler: handler)
        
    }
}
