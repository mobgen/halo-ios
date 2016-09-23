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
    private let serverCachingTime = "86400000"

    static var filePath: NSURL {
        let manager = NSFileManager.defaultManager()
        return manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    }
    
    init() {}

    public func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {
        handler?(true)
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

        let path = getPath("synctimestamp-\(syncQuery.moduleId)")
        
        // Check whether we just sync or re-sync all the content (locale changed)
        if let sync = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? SyncResult, let from = sync.syncTimestamp {
            if sync.locale != syncQuery.locale {
                syncQuery.fromSync = nil
            } else if syncQuery.fromSync == nil {
                syncQuery.fromSync = from
            }
        }
        
        let request = Halo.Request<SyncResult>(router: Router.ModuleSync).params(syncQuery.body).responseParser { any in
            
            var result: SyncResult? = nil
            
            switch any {
            case let d as [String: AnyObject]: // Sync response
                result = SyncResult(data: d)
                result?.moduleId = syncQuery.moduleId
                result?.locale = syncQuery.locale
            default: // Everything else
                break
            }
            
            return result
        }

        let isFirstSync = (syncQuery.fromSync == nil)
        
        if isFirstSync {
            request.addHeader(field: "to-cache", value: serverCachingTime)
        }
        
        // Perform the request
        try! request.responseObject { response, result in
            
            switch result {
            case .Success(let syncResult, _):
                self.processSyncResult(syncQuery, syncResult: syncResult, wasFirstSync: isFirstSync, completionHandler: handler)
            case .Failure(let e):
                LogMessage(error: e).print()
                handler(syncQuery.moduleId, nil)
            }
        }
    }
    
    private func processSyncResult(syncQuery: SyncQuery, syncResult: SyncResult?, wasFirstSync: Bool, completionHandler handler: (String, NSError?) -> Void) -> Void {
        if let result = syncResult {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                var path = self.getPath("synctimestamp-\(result.moduleId)")
                
                // Get the "old" sync info
                if let sync = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? SyncResult, let newLocale = syncResult?.locale {
                    if sync.locale != newLocale {
                        self.removeSyncedInstances(sync.moduleId)
                    }
                }
                
                // Save the new sync info
                NSKeyedArchiver.archiveRootObject(result, toFile: path)
                
                // Get the instances (if any)
                var instanceIds = NSKeyedUnarchiver.unarchiveObjectWithFile(self.getPath("sync-\(result.moduleId)")) as? Set<String> ?? Set<String>()
                
                result.created.forEach { NSKeyedArchiver.archiveRootObject($0, toFile: self.getPath($0.id!)); instanceIds.insert($0.id!) }
                result.updated.forEach { NSKeyedArchiver.archiveRootObject($0, toFile: self.getPath($0.id!)); instanceIds.insert($0.id!) }
                result.deleted.forEach { instanceIds.remove($0); try! NSFileManager.defaultManager().removeItemAtPath(self.getPath($0)) }
                
                path = self.getPath("sync-\(result.moduleId)")
                NSKeyedArchiver.archiveRootObject(instanceIds, toFile: path)

                // Store a log entry for this sync
                path = self.getPath("synclog-\(result.moduleId)")

                var logEntries = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [SyncLogEntry] ?? []
                logEntries.append(SyncLogEntry(result: result))
                NSKeyedArchiver.archiveRootObject(logEntries, toFile: path)

                if wasFirstSync {
                    // Sync again. The first sync might be cached so we need to resync in case there have been changes
                    let query = syncQuery
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
        let path = getPath("sync-\(moduleId)")
        
        if let instanceIds = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? Set<String> {
            instanceIds.forEach { try! NSFileManager.defaultManager().removeItemAtPath(self.getPath($0)) }
            try! NSFileManager.defaultManager().removeItemAtPath(path)
            try! NSFileManager.defaultManager().removeItemAtPath(self.getPath("synctimestamp-\(moduleId)"))
        }
    }

    public func getSyncLog(moduleId: String) -> [SyncLogEntry] {
        let path = self.getPath("synclog-\(moduleId)")
        return NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [SyncLogEntry] ?? []

    }
}
