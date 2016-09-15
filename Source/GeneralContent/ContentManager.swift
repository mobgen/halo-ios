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
public class ContentManager: HaloManager {

    public var defaultLocale: Halo.Locale?
    private let serverCachingTime = "86400"

    init() {}

    public func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {

    }

    // MARK: Get instances

    public func search(searchQuery: Halo.SearchQuery, completionHandler handler: (NSHTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void {
        Manager.core.dataProvider.search(searchQuery, completionHandler: handler)
    }

    // MARK: Sync instances from a module

    public func sync(syncQuery: SyncQuery, completionHandler handler: (String, NSError?) -> Void) -> Void {

        if syncQuery.fromSync == nil {
            if let sync = NSKeyedUnarchiver.unarchiveObjectWithFile("synctimestamp-\(syncQuery.moduleName)") as? SyncResult, let from = sync.syncTimestamp {
                syncQuery.fromSync = from
            }
        }
        
        let request = Halo.Request<SyncResult>(router: Router.ModuleSync).params(syncQuery.body).skipPagination().responseParser { any in
            
            var result: SyncResult? = nil
            
            switch any {
            case let d as [String: AnyObject]: // Sync response
                result = SyncResult(data: d)
            default: // Everything else
                break
            }
            
            return result
        }

        if syncQuery.fromSync == nil {
            request.addHeader(field: "to-cache", value: serverCachingTime)
        }
        
        try! request.responseObject { response, result in
            
            switch result {
            case .Success(let syncResult, _):
                
                if let result = syncResult {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        NSKeyedArchiver.archiveRootObject(result, toFile: "synctimestamp-\(result.moduleName)")
                        
                        var instanceIds = NSKeyedUnarchiver.unarchiveObjectWithFile("sync-\(result.moduleName)") as? Set<String> ?? Set<String>()
                        
                        let _ = result.created.map { NSKeyedArchiver.archiveRootObject($0, toFile: $0.id!); instanceIds.insert($0.id!) }
                        let _ = result.updated.map { NSKeyedArchiver.archiveRootObject($0, toFile: $0.id!); instanceIds.insert($0.id!) }
                        let _ = result.deleted.map { instanceIds.remove($0); try! NSFileManager.defaultManager().removeItemAtPath($0) }
                        
                        NSKeyedArchiver.archiveRootObject(instanceIds, toFile: "sync-\(result.moduleName)")
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            handler(result.moduleName, nil)
                        }
                    }
                }
            case .Failure(let e):
                LogMessage(error: e).print()
                handler(syncQuery.moduleName, e)
            }
        }
    }
    
    public func getSyncedInstances(moduleName: String) -> [ContentInstance]? {
        
        // Get the ids of the instances for the given module
        if let instanceIds = NSKeyedUnarchiver.unarchiveObjectWithFile("sync-\(moduleName)") as? [String] {
            return instanceIds.map { NSKeyedUnarchiver.unarchiveObjectWithFile($0) as! ContentInstance }
        } else {
            // No instance ids have been found for that module
            return nil
        }
        
    }
}
