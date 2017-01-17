//
//  HaloGeneralContentManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Halo

@objc
public enum ContentFlags: Int {
    case none, includeArchived, includeUnpublished, includeArchivedAndUnpublished
}

public extension ContentManager {
    
    @objc(searchWithQuery:success:failure:)
    public func search(query: Halo.SearchQuery,
                             success: @escaping (HTTPURLResponse?, PaginatedContentInstances) -> Void,
                             failure: @escaping (HTTPURLResponse?, NSError) -> Void) -> Void {
        Manager.core.dataProvider.search(query: query) { (response, result) in
            switch result {
            case .success(let data, _):
                if let instances = data {
                    success(response, instances)
                }
            case .failure(let error):
                failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: error.description]))
            }
        }
    }
    
    @objc(syncWithQuery:completionHandler:)
    public func syncObjC(query: SyncQuery, completionHandler handler: @escaping (String, NSError?) -> Void) -> Void {
        
        self.sync(query: query) { (moduleId, error) in
            
            var info: [AnyHashable: String]? = nil
            
            if let error = error {
                info = [NSLocalizedDescriptionKey: error.description]
            }
            
            handler(moduleId, NSError(domain: "com.mobgen.halo", code: -1, userInfo: info))
            
        }
    }
    
}
