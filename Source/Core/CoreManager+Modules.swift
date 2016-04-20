//
//  Manager+Modules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 11/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

extension CoreManager: ModulesProvider {
 
    /**
     Get a list of the existing modules for the provided client credentials
     
     - parameter offlinePolicy: Offline policy to be considered when retrieving data
     - parameter completionHandler:  Closure to be executed when the request has finished
     */
    public func getModules(offlinePolicy: OfflinePolicy? = nil) -> Halo.Request {
        
        let request = Halo.Request(router: Router.Modules)
            
        if let offline = offlinePolicy {
            return request.offlinePolicy(offline)
        }
        
        return request
    }

}