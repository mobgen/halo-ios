//
//  ContentManager+Sync+ModuleName.swift
//  Halo
//
//  Created by Fernando Souto on 28/11/17.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

import Foundation

extension ContentManager {
    
    fileprivate func getPath(file: String) -> String {
        return ContentManager.filePath.appendingPathComponent(file).path
    }
    
    // MARK: Sync instances from a module
    
    public func syncByName(query: SyncQuery, completionHandler handler: @escaping (String, HaloError?) -> Void) -> Void {
        
        let path = getPath(file: "synctimestamp-\(query.moduleName!)")
        
        // Check whether we just sync or re-sync all the content (locale changed)
        if let sync = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? SyncResult, let from = sync.syncDate {
            if sync.locale != query.locale {
                query.fromSync(nil)
            } else if query.fromSync == nil {
                query.fromSync(from)
            }
        }
        
        let request = Halo.Request<SyncResult>(Router.moduleSync).params(query.body).responseParser { any in
            
            var result: SyncResult? = nil
            
            switch any {
            case let d as [String: AnyObject]: // Sync response
                result = SyncResult(data: d)
                result?.moduleName = query.moduleName!
                result?.locale = query.locale
            default: // Everything else
                break
            }
            
            return result
        }
        
        let isFirstSync = (query.fromSync == nil)
        
        if isFirstSync {
            request.serverCache(seconds: serverCachingTime)
        }
        
        // Perform the request
        try! request.responseObject { response, result in
            
            switch result {
            case .success(let syncResult, _):
                self.processSyncResult(query, syncResult: syncResult, wasFirstSync: isFirstSync, completionHandler: handler)
            case .failure(let e):
                Manager.core.logMessage(e.description, level: .error)
                handler(query.moduleName!, e)
            }
        }
    }
    
    fileprivate func processSyncResult(_ syncQuery: SyncQuery, syncResult: SyncResult?, wasFirstSync: Bool, completionHandler handler: @escaping (String, HaloError?) -> Void) -> Void {
        if let result = syncResult {
            
            DispatchQueue.global(qos: .background).async {
                var path = self.getPath(file: "synctimestamp-\(result.moduleName)")
                
                // Get the "old" sync info
                if let sync = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? SyncResult, let newLocale = syncResult?.locale {
                    if sync.locale != newLocale {
                        self.removeSyncedInstancesByName(moduleName: sync.moduleName)
                    }
                }
                
                // Save the new sync info
                NSKeyedArchiver.archiveRootObject(result, toFile: path)
                
                // Get the instances (if any)
                var instanceIds = NSKeyedUnarchiver.unarchiveObject(withFile: self.getPath(file: "sync-\(result.moduleName)")) as? Set<String> ?? Set<String>()
                
                result.created.forEach { NSKeyedArchiver.archiveRootObject($0, toFile: self.getPath(file: $0.id!)); instanceIds.insert($0.id!) }
                result.updated.forEach { NSKeyedArchiver.archiveRootObject($0, toFile: self.getPath(file: $0.id!)); instanceIds.insert($0.id!) }
                
                result.deleted.forEach { instanceId in
                    instanceIds.remove(instanceId)
                    
                    do {
                        try FileManager.default.removeItem(atPath: self.getPath(file: instanceId))
                    } catch {
                        Manager.core.logMessage("Error deleting instance \(instanceId)", level: .error)
                    }
                }
                
                path = self.getPath(file: "sync-\(result.moduleName)")
                NSKeyedArchiver.archiveRootObject(instanceIds, toFile: path)
                
                // Store a log entry for this sync
                path = self.getPath(file: "synclog-\(result.moduleName)")
                
                var logEntries = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [SyncLogEntry] ?? []
                logEntries.append(SyncLogEntry(result: result))
                NSKeyedArchiver.archiveRootObject(logEntries, toFile: path)
                
                if wasFirstSync {
                    // Sync again. The first sync might be cached so we need to resync in case there have been changes
                    let query = syncQuery
                    query.fromSync(result.syncDate)
                    self.sync(query: query, completionHandler: handler)
                } else {
                    DispatchQueue.main.async {
                        handler(result.moduleId, nil)
                    }
                }
            }
        }
    }
    
    @objc(syncedInstancesForModuleName:)
    public func getSyncedInstancesByName(moduleName: String) -> [ContentInstance] {
        
        // Get the ids of the instances for the given module
        if let instanceIds = NSKeyedUnarchiver.unarchiveObject(withFile: getPath(file: "sync-\(moduleName)")) as? Set<String> {
            return instanceIds.map { NSKeyedUnarchiver.unarchiveObject(withFile: self.getPath(file: $0)) as! ContentInstance }
        } else {
            // No instance ids have been found for that module
            return []
        }
    }
    
    @objc(removeSyncedInstancesForModuleName:)
    public func removeSyncedInstancesByName(moduleName: String) -> Void {
        let path = getPath(file: "sync-\(moduleName)")
        
        if let instanceIds = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Set<String> {
            instanceIds.forEach { instanceId in
                try? FileManager.default.removeItem(atPath: self.getPath(file: instanceId))
            }
            try? FileManager.default.removeItem(atPath: path)
            try? FileManager.default.removeItem(atPath: self.getPath(file: "synctimestamp-\(moduleName)"))
            clearSyncLogByName(moduleName: moduleName)
        }
    }
    
    @objc(syncLogForModuleName:)
    public func getSyncLogByName(moduleName: String) -> [SyncLogEntry] {
        let path = self.getPath(file: "synclog-\(moduleName)")
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [SyncLogEntry] ?? []
    }
    
    @objc(clearSyncLogForModuleName:)
    public func clearSyncLogByName(moduleName: String) -> Void {
        let path = self.getPath(file: "synclog-\(moduleName)")
        
        try? FileManager.default.removeItem(atPath: path)
    }
    
}
