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
    
    let serverCachingTime = "86400000"
    
    static var filePath: URL {
        let manager = FileManager.default
        return manager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    fileprivate override init() {
        super.init()
    }

    @objc(startup:)
    open func startup(_ handler: ((Bool) -> Void)?) -> Void {
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
}

public extension Manager {
    
    public static let content: ContentManager = {
        return ContentManager()
    }()
    
}
