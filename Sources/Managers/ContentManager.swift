//
//  GeneralContent.swift
//  HaloSDK
//
//  Created by Borja on 31/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/**
 Access point to the General Content. This class will provide methods to obtain the data stored as general content.
 */
@objc(HaloContentManager)
open class ContentManager: NSObject, HaloManager {

    open var defaultLocale: Halo.Locale = .englishUnitedStates
    
    let serverCachingTime: Int = 86400
    
    static var filePath: URL {
        let manager = FileManager.default
        return manager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    fileprivate override init() {
        super.init()
    }

    @objc(startup:completionHandler:)
    open func startup(_ app: UIApplication, completionHandler handler: ((Bool) -> Void)?) -> Void {
        handler?(true)
    }

    // MARK: Get instances

    open func search(query: Halo.SearchQuery, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void {
        Manager.core.dataProvider.search(query: query, completionHandler: handler)
    }

    open func searchAsData(query: Halo.SearchQuery, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<Data>) -> Void) -> Void {
        Manager.core.dataProvider.searchAsData(query: query, completionHandler: handler)
    }
    
    // MARK: Content manipulation
    
    open func save(_ instance: ContentInstance, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<ContentInstance?>) -> Void) -> Void {
        Manager.core.dataProvider.save(instance: instance, completionHandler: handler)
    }
    
    open func delete(instanceId: String, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<ContentInstance?>) -> Void) -> Void {
        Manager.core.dataProvider.delete(id: instanceId, completionHandler: handler)
    }
    
    // MARK: Batch operations
    
    open func batch(operations: BatchOperations, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<BatchResult?>) -> Void) -> Void {
        Manager.core.dataProvider.batch(operations: operations, completionHandler: handler)
    }
    
    // Objective C extension
    
    // MARK: Content search
    
    @objc(searchWithQuery:success:failure:)
    func search(query: Halo.SearchQuery,
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
    func searchAsData(query: Halo.SearchQuery,
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
    func saveInstance(_ instance: ContentInstance,
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
    func deleteInstance(_ instanceId: String,
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
    func performBatchOperations(_ operations: BatchOperations,
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
    func syncObjC(query: SyncQuery, completionHandler handler: @escaping (String, Error?) -> Void) -> Void {
        
        self.sync(query: query) { (moduleId, error) in
            
            var info: [String: Any]? = nil
            
            if let error = error {
                info = [NSLocalizedDescriptionKey: error.description]
            }
            
            handler(moduleId, NSError(domain: "com.mobgen.halo", code: -1, userInfo: info))
            
        }
    }
}

@objc public extension Manager {
    
    @objc static let content: ContentManager = {
        return ContentManager()
    }()
    
}
