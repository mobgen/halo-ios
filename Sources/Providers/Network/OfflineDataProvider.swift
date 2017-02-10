//
//  OfflineDataProvider.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 13/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

open class OfflineDataProvider: DataProvider {

    static var filePath: URL {
        let manager = FileManager.default
        return manager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    static var modulesPath: String {
        return OfflineDataProvider.filePath.appendingPathComponent("modules").path
    }

    open func getModules(completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<PaginatedModules?>) -> Void) -> Void {

        if let modules = NSKeyedUnarchiver.unarchiveObject(withFile: OfflineDataProvider.modulesPath) as? PaginatedModules {
            handler(nil, .success(modules, true))
        } else {
            handler(nil, .failure(.noCachedContent))
        }
    }

    open func search(query: Halo.SearchQuery, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void {

        if let instances = NSKeyedUnarchiver.unarchiveObject(withFile: query.description) as? PaginatedContentInstances {
            handler(nil, .success(instances, true))
        } else {
            handler(nil, .failure(.noCachedContent))
        }

    }
    
    public func save(instance: ContentInstance, completionHandler handler: @escaping (HTTPURLResponse?, Result<ContentInstance?>) -> Void) -> Void {
        handler(nil, .failure(.noInternetConnection))
    }
    
    public func delete(id: String, completionHandler handler: @escaping (HTTPURLResponse?, Result<ContentInstance?>) -> Void) -> Void {
        handler(nil, .failure(.noInternetConnection))
    }

}
