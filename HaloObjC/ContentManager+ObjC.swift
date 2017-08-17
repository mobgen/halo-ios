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
                             failure: @escaping (HTTPURLResponse?, Error) -> Void) -> Void {
        
        self.search(query: query) { (response, result) in
            switch result {
            case .success(let data, _):
                if let instances = data {
                    success(response, instances)
                } else {
                    failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server"]))
                }
            case .failure(let error):
                failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: error.description]))
            }
        }
    }
    
    @objc(searchAsDataWithQuery:success:failure:)
    public func searchAsData(query: Halo.SearchQuery,
                             success: @escaping (HTTPURLResponse?, Data) -> Void,
                             failure: @escaping (HTTPURLResponse?, Error) -> Void) -> Void {
    
        self.searchAsData(query: query) { (response, result) in
            
            switch result {
            case .success(let data, _):
                success(response, data)
            case .failure(let error):
                failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: error.description]))
            }
        }
        
    }
    
    @objc(syncWithQuery:completionHandler:)
    public func syncObjC(query: SyncQuery, completionHandler handler: @escaping (String, Error?) -> Void) -> Void {
        
        self.sync(query: query) { (moduleId, error) in
            
            var info: [AnyHashable: String]? = nil
            
            if let error = error {
                info = [NSLocalizedDescriptionKey: error.description]
            }
            
            handler(moduleId, NSError(domain: "com.mobgen.halo", code: -1, userInfo: info))
            
        }
    }
    
}
