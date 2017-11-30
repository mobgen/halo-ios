//
//  ContentManager+Sync.swift
//  Halo
//
//  Created by Borja Santos-Díez on 16/01/17.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

import Foundation

extension ContentManager {
    
    fileprivate func getPath(file: String) -> String {
        return ContentManager.filePath.appendingPathComponent(file).path
    }
    
    fileprivate func isQueryFromId(_ query: SyncQuery) -> Bool {
        if query.moduleId != nil {
           return true
        } else {
            return false
        }
    }
    
    
    fileprivate func getModuleIdetifier(query: SyncQuery) -> String{
        var filePath = ""
        if let moduleId = query.moduleId {
            filePath = moduleId
        } else if let moduleName = query.moduleName {
            filePath = moduleName
        }
        return filePath;
    }
    
    // MARK: Sync instances from a module
    
    public func sync(query: SyncQuery, completionHandler handler: @escaping (String, HaloError?) -> Void) -> Void {
        
        let path = getPath(file: "synctimestamp-\(getModuleIdetifier(query: query))")
        
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
                if(self.isQueryFromId(query)){
                    result?.moduleId = self.getModuleIdetifier(query: query)
                } else {
                    result?.moduleName = self.getModuleIdetifier(query: query)
                }
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
                handler(self.getModuleIdetifier(query: query), e)
            }
        }
    }
    
    fileprivate func processSyncResult(_ syncQuery: SyncQuery, syncResult: SyncResult?, wasFirstSync: Bool, completionHandler handler: @escaping (String, HaloError?) -> Void) -> Void {
        if let result = syncResult {
            
            DispatchQueue.global(qos: .background).async {
                
                var path = self.getPath(file: "synctimestamp-\(self.getModuleIdetifier(query: syncQuery))")
                
                // Get the "old" sync info
                if let sync = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? SyncResult, let newLocale = syncResult?.locale {
                    if sync.locale != newLocale {
                        self.removeSyncedInstances(module: self.getModuleIdetifier(query: syncQuery))
                    }
                }
                
                // Save the new sync info
                NSKeyedArchiver.archiveRootObject(result, toFile: path)
                
                // Get the instances (if any)
                var instanceIds = NSKeyedUnarchiver.unarchiveObject(withFile: self.getPath(file: "sync-\(self.getModuleIdetifier(query: syncQuery))")) as? Set<String> ?? Set<String>()
                
                result.created.forEach { NSKeyedArchiver.archiveRootObject($0, toFile: self.getPath(file: $0.id!)); instanceIds.insert($0.id!) }
                result.updated.forEach { NSKeyedArchiver.archiveRootObject($0, toFile: self.getPath(file: $0.id!)); instanceIds.insert($0.id!) }
                
                result.deleted.forEach { instanceId in
                    instanceIds.remove(instanceId)
                    
                    do {
                        try FileManager.default.removeItem(atPath: self.getPath(file: instanceId))
                    } catch {
                        Manager.core.logMessage("Error deleting instance \(self.getModuleIdetifier(query: syncQuery))", level: .error)
                    }
                }
                
                path = self.getPath(file: "sync-\(self.getModuleIdetifier(query: syncQuery))")
                NSKeyedArchiver.archiveRootObject(instanceIds, toFile: path)
                
                // Store a log entry for this sync
                path = self.getPath(file: "synclog-\(self.getModuleIdetifier(query: syncQuery))")
                
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
                        handler(self.getModuleIdetifier(query: syncQuery), nil)
                    }
                }
            }
        }
    }
    
    @objc(syncedInstancesForModule:)
    public func getSyncedInstances(module: String) -> [ContentInstance] {
        
        // Get the ids of the instances for the given module
        if let instanceIds = NSKeyedUnarchiver.unarchiveObject(withFile: getPath(file: "sync-\(module)")) as? Set<String> {
            return instanceIds.map { NSKeyedUnarchiver.unarchiveObject(withFile: self.getPath(file: $0)) as! ContentInstance }
        } else {
            // No instance ids have been found for that module
            return []
        }
    }
    
    @objc(removeSyncedInstancesForModule:)
    public func removeSyncedInstances(module: String) -> Void {
        let path = getPath(file: "sync-\(module)")
        
        if let instanceIds = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Set<String> {
            instanceIds.forEach { instanceId in
                try? FileManager.default.removeItem(atPath: self.getPath(file: instanceId))
            }
            try? FileManager.default.removeItem(atPath: path)
            try? FileManager.default.removeItem(atPath: self.getPath(file: "synctimestamp-\(module)"))
            clearSyncLog(module: module)
        }
    }
    
    @objc(syncLogForModule:)
    public func getSyncLog(module: String) -> [SyncLogEntry] {
        let path = self.getPath(file: "synclog-\(module)")
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [SyncLogEntry] ?? []
    }
    
    @objc(clearSyncLogForModule:)
    public func clearSyncLog(module: String) -> Void {
        let path = self.getPath(file: "synclog-\(module)")
        
        try? FileManager.default.removeItem(atPath: path)
    }
    
}

