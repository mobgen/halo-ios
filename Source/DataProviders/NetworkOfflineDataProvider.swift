//
//  NetworkOfflineDataProvider.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 13/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public class NetworkOfflineDataProvider: NetworkDataProvider {

    public override func getModules(completionHandler handler: (NSHTTPURLResponse?, Halo.Result<PaginatedModules?>) -> Void) -> Void {

        super.getModules { response, result in
            switch result {
            case .Success(let data, _):
                if let d = data {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        NSKeyedArchiver.archiveRootObject(d, toFile: OfflineDataProvider.modulesPath)
                    }
                }
                handler(response, .Success(data, false))
            case .Failure(_):
                if let modules = NSKeyedUnarchiver.unarchiveObjectWithFile(OfflineDataProvider.modulesPath) as? PaginatedModules {
                    handler(response, .Success(modules, true))
                } else {
                    handler(response, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
                }
            }
        }

    }

    public override func search(searchQuery: Halo.SearchQuery, completionHandler handler: (NSHTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void {

        super.search(searchQuery) { response, result in

            let path = OfflineDataProvider.filePath.URLByAppendingPathComponent("search-(\(searchQuery.hash))")!.path!

            switch result {
            case .Success(let data, _):
                if let d = data {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        NSKeyedArchiver.archiveRootObject(d, toFile: path)
                    }
                }
                handler(response, .Success(data, false))
            case .Failure(_):
                if let instances = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? PaginatedContentInstances {
                    handler(response, .Success(instances, true))
                } else {
                    handler(response, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
                }
            }

        }

    }

}
