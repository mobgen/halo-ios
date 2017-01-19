//
//  DataProvider.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public protocol DataProvider {

    func getModules(completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<PaginatedModules?>) -> Void) -> Void
    func search(query: Halo.SearchQuery, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void
    func save(instance: ContentInstance, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<ContentInstance?>) -> Void) -> Void
    func delete(id: String, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<ContentInstance?>) -> Void) -> Void

}

struct DataProviderManager {
    
    static let online: NetworkDataProvider = NetworkDataProvider()
    static let onlineOffline: NetworkOfflineDataProvider = NetworkOfflineDataProvider()
    static let offline: OfflineDataProvider = OfflineDataProvider()
    
}
