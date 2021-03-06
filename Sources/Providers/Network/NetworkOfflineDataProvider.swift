//
//  NetworkOfflineDataProvider.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 13/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

open class NetworkOfflineDataProvider: NetworkDataProvider {

    open override func getModules(query: ModulesQuery, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<PaginatedModules?>) -> Void) -> Void {

        super.getModules(query: query) { response, result in
            switch result {
            case .success(let data, _):
                if let d = data {
                    DispatchQueue.global(qos: .background).async {
                        NSKeyedArchiver.archiveRootObject(d, toFile: OfflineDataProvider.modulesPath)
                    }
                }
                handler(response, .success(data, false))
            case .failure(let e):
                if let modules = NSKeyedUnarchiver.unarchiveObject(withFile: OfflineDataProvider.modulesPath) as? PaginatedModules {
                    handler(response, .success(modules, true))
                } else {
                    handler(response, .failure(e))
                }
            }
        }

    }

    open override func search(query: Halo.SearchQuery, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void {

        super.search(query: query) { response, result in

            let path = OfflineDataProvider.filePath.appendingPathComponent("search-(\(query.hash))").path

            switch result {
            case .success(let data, _):
                if let d = data {
                    DispatchQueue.global(qos: .background).async {
                        NSKeyedArchiver.archiveRootObject(d, toFile: path)
                    }
                }
                handler(response, .success(data, false))
            case .failure(let e):
                if let instances = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? PaginatedContentInstances {
                    handler(response, .success(instances, true))
                } else {
                    handler(response, .failure(e))
                }
            }

        }

    }

}
