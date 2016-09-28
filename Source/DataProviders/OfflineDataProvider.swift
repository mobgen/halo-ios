//
//  OfflineDataProvider.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 13/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public class OfflineDataProvider: DataProvider {

    static var filePath: NSURL {
        let manager = NSFileManager.defaultManager()
        return manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    }

    static var modulesPath: String {
        return OfflineDataProvider.filePath.URLByAppendingPathComponent("modules")!.path!
    }

    public func getModules(completionHandler handler: (NSHTTPURLResponse?, Halo.Result<PaginatedModules?>) -> Void) -> Void {

        if let modules = NSKeyedUnarchiver.unarchiveObjectWithFile(OfflineDataProvider.modulesPath) as? PaginatedModules {
            handler(nil, .Success(modules, true))
        } else {
            handler(nil, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
        }
    }

    public func search(query query: Halo.SearchQuery, completionHandler handler: (NSHTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void {

        if let instances = NSKeyedUnarchiver.unarchiveObjectWithFile(query.description) as? PaginatedContentInstances {
            handler(nil, .Success(instances, true))
        } else {
            handler(nil, .Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
        }

    }

}
