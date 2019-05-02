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
    
    // MARK: Content search
    
    @objc(searchWithQuery:success:failure:)
    public func search(query: Halo.SearchQuery,
                             success: @escaping (HTTPURLResponse?, PaginatedContentInstances, Bool) -> Void,
                             failure: @escaping (HTTPURLResponse?, Error) -> Void) -> Void {
        
        self.search(query: query) { (response, result) in
            switch result {
            case .success(let data, let cached):
                if let instances = data {
                    success(response, instances, cached)
                } else {
                    failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server"]))
                }
            case .failure(let error):
                failure(response, error)
            }
        }
    }
    
    @objc(searchAsDataWithQuery:success:failure:)
    public func searchAsData(query: Halo.SearchQuery,
                             success: @escaping (HTTPURLResponse?, Data, Bool) -> Void,
                             failure: @escaping (HTTPURLResponse?, Error) -> Void) -> Void {
    
        self.searchAsData(query: query) { (response, result) in
            
            switch result {
            case .success(let data, let cached):
                success(response, data, cached)
            case .failure(let error):
                failure(response, error)
            }
        }
        
    }
    
    // Content manipulation
    
    @objc(saveInstance:withSuccess:failure:)
    public func saveInstance(_ instance: ContentInstance,
                             success: @escaping (HTTPURLResponse?, ContentInstance?, Bool) -> Void,
                             failure: @escaping (HTTPURLResponse?, Error) -> Void) {
        
        self.save(instance) { (response, result) in
            switch result {
            case .success(let instance, let cached):
                success(response, instance, cached)
            case .failure(let error):
                failure(response, error)
            }
        }
        
    }
    
    @objc(deleteInstanceWithId:success:failure:)
    public func deleteInstance(_ instanceId: String,
                               success: @escaping (HTTPURLResponse?, ContentInstance?, Bool) -> Void,
                               failure: @escaping (HTTPURLResponse?, Error) -> Void) {
        
        self.delete(instanceId: instanceId) { (response, result) in
            switch result {
            case .success(let instance, let cached):
                success(response, instance, cached)
            case .failure(let error):
                failure(response, error)
            }
        }
        
    }
    
    // MARK: Batch operations
    
    @objc(performBatchOperations:withSuccess:failure:)
    public func performBatchOperations(_ operations: BatchOperations,
                                       success: @escaping (HTTPURLResponse?, BatchResult?, Bool) -> Void,
                                       failure: @escaping (HTTPURLResponse?, Error) -> Void) {
     
        self.batch(operations: operations) { (response, result) in
            switch result {
            case .success(let batchResult, let cached):
                success(response, batchResult, cached)
            case .failure(let error):
                failure(response, error)
            }
        }
        
    }
    
    // MARK: Content sync
    
    @objc(syncWithQuery:completionHandler:)
    public func syncObjC(query: SyncQuery, completionHandler handler: @escaping (String, Error?) -> Void) -> Void {
        
        self.sync(query: query) { (moduleId, error) in
            
            var info: [String: Any]? = nil
            
            if let error = error {
                info = [NSLocalizedDescriptionKey: error.description]
            }
            
            handler(moduleId, NSError(domain: "com.mobgen.halo", code: -1, userInfo: info))
            
        }
    }

}
