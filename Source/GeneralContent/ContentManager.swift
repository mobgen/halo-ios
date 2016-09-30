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
public class ContentManager: NSObject, HaloManager {

    public var defaultLocale: Halo.Locale?
    private let serverCachingTime = "86400000"

    static var filePath: NSURL {
        let manager = NSFileManager.defaultManager()
        return manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    }
    
    override init() {
        super.init()
    }

    public func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {
        handler?(true)
    }

    private func getPath(file file: String) -> String {
        return ContentManager.filePath.URLByAppendingPathComponent(file)!.path!
    }
    
    // MARK: Get instances

    public func search(query query: Halo.SearchQuery, completionHandler handler: (NSHTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void {
        Manager.core.dataProvider.search(query: query, completionHandler: handler)
    }

    // MARK: Sync instances from a module

    @objc(syncWithQuery:completionHandler:)
    public func sync(query query: SyncQuery, completionHandler handler: (String, NSError?) -> Void) -> Void {

        let path = getPath(file: "synctimestamp-\(query.moduleId)")
        
        // Check whether we just sync or re-sync all the content (locale changed)
        if let sync = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? SyncResult, let from = sync.syncDate {
            if sync.locale != query.locale {
                query.fromSync(date: nil)
            } else if query.fromSync == nil {
                query.fromSync(date: from)
            }
        }
        
        let request = Halo.Request<SyncResult>(router: Router.ModuleSync).params(params: query.body).responseParser { any in
            
            var result: SyncResult? = nil
            
            switch any {
            case let d as [String: AnyObject]: // Sync response
                result = SyncResult(data: d)
                result?.moduleId = query.moduleId
                result?.locale = query.locale
            default: // Everything else
                break
            }
            
            return result
        }

        let isFirstSync = (query.fromSync == nil)
        
        if isFirstSync {
            request.addHeader(field: "to-cache", value: serverCachingTime)
        }
        
        // Perform the request
        try! request.responseObject { response, result in
            
            switch result {
            case .Success(let syncResult, _):
                self.processSyncResult(query, syncResult: syncResult, wasFirstSync: isFirstSync, completionHandler: handler)
            case .Failure(let e):
                LogMessage(error: e).print()
                handler(query.moduleId, nil)
            }
        }
    }
    
    private func processSyncResult(syncQuery: SyncQuery, syncResult: SyncResult?, wasFirstSync: Bool, completionHandler handler: (String, NSError?) -> Void) -> Void {
        if let result = syncResult {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                var path = self.getPath(file: "synctimestamp-\(result.moduleId)")
                
                // Get the "old" sync info
                if let sync = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? SyncResult, let newLocale = syncResult?.locale {
                    if sync.locale != newLocale {
                        self.removeSyncedInstances(sync.moduleId)
                    }
                }
                
                // Save the new sync info
                NSKeyedArchiver.archiveRootObject(result, toFile: path)
                
                // Get the instances (if any)
                var instanceIds = NSKeyedUnarchiver.unarchiveObjectWithFile(self.getPath(file: "sync-\(result.moduleId)")) as? Set<String> ?? Set<String>()
                
                result.created.forEach { NSKeyedArchiver.archiveRootObject($0, toFile: self.getPath(file: $0.id!)); instanceIds.insert($0.id!) }
                result.updated.forEach { NSKeyedArchiver.archiveRootObject($0, toFile: self.getPath(file: $0.id!)); instanceIds.insert($0.id!) }
                
                result.deleted.forEach { instanceId in
                    instanceIds.remove(instanceId)
                    
                    do {
                        try NSFileManager.defaultManager().removeItemAtPath(self.getPath(file: instanceId))
                    } catch {
                        LogMessage(message: "Error deleting instance \(instanceId)", level: .Error).print()
                    }
                }
                
                path = self.getPath(file: "sync-\(result.moduleId)")
                NSKeyedArchiver.archiveRootObject(instanceIds, toFile: path)

                // Store a log entry for this sync
                path = self.getPath(file: "synclog-\(result.moduleId)")

                var logEntries = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [SyncLogEntry] ?? []
                logEntries.append(SyncLogEntry(result: result))
                NSKeyedArchiver.archiveRootObject(logEntries, toFile: path)

                if wasFirstSync {
                    // Sync again. The first sync might be cached so we need to resync in case there have been changes
                    let query = syncQuery
                    query.fromSync(date: result.syncDate)
                    self.sync(query: query, completionHandler: handler)
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        handler(result.moduleId, nil)
                    }
                }
            }
        }
    }

    @objc(syncedInstancesForModule:)
    public func getSyncedInstances(moduleId: String) -> [ContentInstance] {
        
        // Get the ids of the instances for the given module
        if let instanceIds = NSKeyedUnarchiver.unarchiveObjectWithFile(getPath(file: "sync-\(moduleId)")) as? Set<String> {
            return instanceIds.map { NSKeyedUnarchiver.unarchiveObjectWithFile(self.getPath(file: $0)) as! ContentInstance }
        } else {
            // No instance ids have been found for that module
            return []
        }
    }
    
    @objc(removeSyncedInstancesForModule:)
    public func removeSyncedInstances(moduleId: String) -> Void {
        let path = getPath(file: "sync-\(moduleId)")
        
        if let instanceIds = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? Set<String> {
            do {
                try instanceIds.forEach { instanceId in
                    try NSFileManager.defaultManager().removeItemAtPath(self.getPath(file: instanceId))
                }
                try NSFileManager.defaultManager().removeItemAtPath(path)
                try NSFileManager.defaultManager().removeItemAtPath(self.getPath(file: "synctimestamp-\(moduleId)"))
            } catch {
                
            }
        }
    }

    @objc(syncLogForModule:)
    public func getSyncLog(moduleId: String) -> [SyncLogEntry] {
        let path = self.getPath(file: "synclog-\(moduleId)")
        return NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [SyncLogEntry] ?? []
    }
    
    func clearSyncLog(moduleId: String) -> Void {
        let path = self.getPath(file: "synclog-\(moduleId)")
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch {}
    }
}
