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
    public func modules(_ success: @escaping (HTTPURLResponse?, PaginatedModules) -> Void,
                        failure: @escaping (HTTPURLResponse?, NSError) -> Void) -> Void {

        self.getModules { (response, result) in

            switch result {
            case .success(let data, _):
                if let modules = data {
                    success(response, modules)
                }
            case .failure(let error):
                failure(response, error)
            }
        }
    }
    
    @objc(setEnvironment:withCompletionHandler:)
    public func setEnvironment(environment env: String, completionHandler handler: ((Bool) -> Void)? = nil) -> Void {
        
        var envir: HaloEnvironment!
        
        switch env.lowercased() {
        case "int":
            envir = .int
        case "prod":
            envir = .prod
        case "stage":
            envir = .stage
        case "qa":
            envir = .qa
        default:
            envir = .custom(env)
        }
        
        self.setEnvironment(environment: envir, completionHandler: handler)
        
    }
}
