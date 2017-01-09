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

    open var defaultLocale: Halo.Locale?
    fileprivate let serverCachingTime = "86400000"

    static var filePath: URL {
        let manager = FileManager.default
        return manager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    override init() {
        super.init()
    }

    @objc(startup:)
    open func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {
        handler?(true)
    }

    fileprivate func getPath(file: String) -> String {
        return ContentManager.filePath.appendingPathComponent(file).path
    }
    
    // MARK: Get instances

    open func search(query: Halo.SearchQuery, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void {
        Manager.core.dataProvider.search(query: query, completionHandler: handler)
    }

    // MARK: Sync instances from a module

    @objc(syncWithQuery:completionHandler:)
    open func sync(query: SyncQuery, completionHandler handler: @escaping (String, NSError?) -> Void) -> Void {

        let path = getPath(file: "synctimestamp-\(query.moduleId)")
        
        // Check whether we just sync or re-sync all the content (locale changed)
        if let sync = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? SyncResult, let from = sync.syncDate {
            if sync.locale != query.locale {
                query.fromSync(date: nil)
            } else if query.fromSync == nil {
                query.fromSync(date: from)
            }
        }
        
        let request = Halo.Request<SyncResult>(router: Router.moduleSync).params(params: query.body).responseParser { any in
            
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
            case .success(let syncResult, _):
                self.processSyncResult(query, syncResult: syncResult, wasFirstSync: isFirstSync, completionHandler: handler)
            case .failure(let e):
                LogMessage(error: e).print()
                handler(query.moduleId, nil)
            }
        }
    }
    
    fileprivate func processSyncResult(_ syncQuery: SyncQuery, syncResult: SyncResult?, wasFirstSync: Bool, completionHandler handler: @escaping (String, NSError?) -> Void) -> Void {
        if let result = syncResult {
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                var path = self.getPath(file: "synctimestamp-\(result.moduleId)")
                
                // Get the "old" sync info
                if let sync = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? SyncResult, let newLocale = syncResult?.locale {
                    if sync.locale != newLocale {
                        self.removeSyncedInstances(sync.moduleId)
                    }
                }
                
                // Save the new sync info
                NSKeyedArchiver.archiveRootObject(result, toFile: path)
                
                // Get the instances (if any)
                var instanceIds = NSKeyedUnarchiver.unarchiveObject(withFile: self.getPath(file: "sync-\(result.moduleId)")) as? Set<String> ?? Set<String>()
                
                result.created.forEach { NSKeyedArchiver.archiveRootObject($0, toFile: self.getPath(file: $0.id!)); instanceIds.insert($0.id!) }
                result.updated.forEach { NSKeyedArchiver.archiveRootObject($0, toFile: self.getPath(file: $0.id!)); instanceIds.insert($0.id!) }
                
                result.deleted.forEach { instanceId in
                    instanceIds.remove(instanceId)
                    
                    do {
                        try FileManager.default.removeItem(atPath: self.getPath(file: instanceId))
                    } catch {
                        LogMessage(message: "Error deleting instance \(instanceId)", level: .error).print()
                    }
                }
                
                path = self.getPath(file: "sync-\(result.moduleId)")
                NSKeyedArchiver.archiveRootObject(instanceIds, toFile: path)

                // Store a log entry for this sync
                path = self.getPath(file: "synclog-\(result.moduleId)")

                var logEntries = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [SyncLogEntry] ?? []
                logEntries.append(SyncLogEntry(result: result))
                NSKeyedArchiver.archiveRootObject(logEntries, toFile: path)

                if wasFirstSync {
                    // Sync again. The first sync might be cached so we need to resync in case there have been changes
                    let query = syncQuery
                    query.fromSync(date: result.syncDate)
                    self.sync(query: query, completionHandler: handler)
                } else {
                    DispatchQueue.main.async {
                        handler(result.moduleId, nil)
                    }
                }
            }
        }
    }

    @objc(syncedInstancesForModule:)
    open func getSyncedInstances(_ moduleId: String) -> [ContentInstance] {
        
        // Get the ids of the instances for the given module
        if let instanceIds = NSKeyedUnarchiver.unarchiveObject(withFile: getPath(file: "sync-\(moduleId)")) as? Set<String> {
            return instanceIds.map { NSKeyedUnarchiver.unarchiveObject(withFile: self.getPath(file: $0)) as! ContentInstance }
        } else {
            // No instance ids have been found for that module
            return []
        }
    }
    
    @objc(removeSyncedInstancesForModule:)
    open func removeSyncedInstances(_ moduleId: String) -> Void {
        let path = getPath(file: "sync-\(moduleId)")
        
        if let instanceIds = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Set<String> {
            do {
                try instanceIds.forEach { instanceId in
                    try FileManager.default.removeItem(atPath: self.getPath(file: instanceId))
                }
                try FileManager.default.removeItem(atPath: path)
                try FileManager.default.removeItem(atPath: self.getPath(file: "synctimestamp-\(moduleId)"))
            } catch {
                
            }
        }
    }

    @objc(syncLogForModule:)
    open func getSyncLog(_ moduleId: String) -> [SyncLogEntry] {
        let path = self.getPath(file: "synclog-\(moduleId)")
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [SyncLogEntry] ?? []
    }
    
    func clearSyncLog(_ moduleId: String) -> Void {
        let path = self.getPath(file: "synclog-\(moduleId)")
        
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {}
    }
}
