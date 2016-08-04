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
     */
    public func getModules(offlinePolicy: OfflinePolicy? = nil) -> Halo.Request<PaginatedModules> {
        
        let request = Halo.Request<PaginatedModules>(router: Router.Modules).responseParser { (any) in
            
            switch any {
            case let data as [String: AnyObject]:
                
                if let pagination = data["pagination"] as? [String: AnyObject], items = data["items"] as? [[String: AnyObject]] {
                    let paginationInfo = PaginationInfo(data: pagination)
                    let modules = items.map { Halo.Module($0) }
                    return PaginatedModules(paginationInfo: paginationInfo, modules: modules)
                }
                return nil
            
            case let data as [[String: AnyObject]]:
                let items = data.map { Halo.Module($0) }
                let paginationInfo = PaginationInfo(page: 1, limit: items.count, offset: 0, totalItems: items.count, totalPages: 1)
                
                return PaginatedModules(paginationInfo: paginationInfo, modules: items)
            
            default:
                return nil
            }
            
        }
            
        if let offline = offlinePolicy {
            return request.offlinePolicy(offline)
        }
        
        return request
    }

}