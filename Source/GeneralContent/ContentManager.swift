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

    static var filePath: NSURL {
        let manager = NSFileManager.defaultManager()
        return manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    }
    
    init() {}

    public func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {

    }

    private func getPath(file: String) -> String {
        return ContentManager.filePath.URLByAppendingPathComponent(file)!.path!
    }
    
    // MARK: Get instances

    public func search(searchQuery: Halo.SearchQuery, completionHandler handler: (NSHTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void {
        Manager.core.dataProvider.search(searchQuery, completionHandler: handler)
    }

    // MARK: Sync instances from a module

    public func sync(syncQuery: SyncQuery, completionHandler handler: (String, NSError?) -> Void) -> Void {

        if syncQuery.fromSync == nil {
            if let sync = NSKeyedUnarchiver.unarchiveObjectWithFile(getPath("synctimestamp-\(syncQuery.moduleId)")) as? SyncResult, let from = sync.syncTimestamp {
                syncQuery.fromSync = from
            }
        }
        
        let request = Halo.Request<SyncResult>(router: Router.ModuleSync).params(syncQuery.body).responseParser { any in
            
            var result: SyncResult? = nil
            
            switch any {
            case let d as [String: AnyObject]: // Sync response
                result = SyncResult(data: d)
                result?.moduleId = syncQuery.moduleId!
            default: // Everything else
                break
            }
            
            return result
        }

        let isFirstSync = (syncQuery.fromSync == nil)
        
        if isFirstSync {
            request.addHeader(field: "to-cache", value: serverCachingTime)
        }
        
        try! request.responseObject { response, result in
            
            switch result {
            case .Success(let syncResult, _):
                self.processSyncResult(syncQuery, syncResult: syncResult, wasFirstSync: isFirstSync, completionHandler: handler)
            case .Failure(let e):
                LogMessage(error: e).print()
                handler(syncQuery.moduleId!, e)
            }
        }
    }
    
    private func processSyncResult(syncQuery: SyncQuery, syncResult: SyncResult?, wasFirstSync: Bool, completionHandler handler: (String, NSError?) -> Void) -> Void {
        if let result = syncResult {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                NSKeyedArchiver.archiveRootObject(result, toFile: self.getPath("synctimestamp-\(result.moduleId)"))
                
                var instanceIds = NSKeyedUnarchiver.unarchiveObjectWithFile(self.getPath("sync-\(result.moduleId)")) as? Set<String> ?? Set<String>()
                
                let _ = result.created.map { NSKeyedArchiver.archiveRootObject($0, toFile: self.getPath($0.id!)); instanceIds.insert($0.id!) }
                let _ = result.updated.map { NSKeyedArchiver.archiveRootObject($0, toFile: self.getPath($0.id!)); instanceIds.insert($0.id!) }
                let _ = result.deleted.map { instanceIds.remove($0); try! NSFileManager.defaultManager().removeItemAtPath(self.getPath($0)) }
                
                let path = self.getPath("sync-\(result.moduleId)")
                NSKeyedArchiver.archiveRootObject(instanceIds, toFile: path)
                
                if wasFirstSync {
                    // Sync again. The first sync might be cached so we need to resync in case there have been changes
                    var query = syncQuery
                    query.fromSync = result.syncTimestamp
                    self.sync(query, completionHandler: handler)
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        handler(result.moduleId, nil)
                    }
                }
            }
        }
    }
    
    public func getSyncedInstances(moduleId: String) -> [ContentInstance]? {
        
        // Get the ids of the instances for the given module
        if let instanceIds = NSKeyedUnarchiver.unarchiveObjectWithFile(getPath("sync-\(moduleId)")) as? Set<String> {
            return instanceIds.map { NSKeyedUnarchiver.unarchiveObjectWithFile(self.getPath($0)) as! ContentInstance }
        } else {
            // No instance ids have been found for that module
            return nil
        }
    }
    
    public func removeSyncedInstances(moduleId: String) -> Void {
        if let instanceIds = NSKeyedUnarchiver.unarchiveObjectWithFile(getPath("sync-\(moduleId)")) as? Set<String> {
            instanceIds.map { try! NSFileManager.defaultManager().removeItemAtPath(self.getPath($0)) }
        }
    }
}
