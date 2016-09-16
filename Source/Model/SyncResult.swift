//
//  SyncResult.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 15/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloSyncResult)
public class SyncResult: NSObject, NSCoding {
    
    struct Keys {
        static let ModuleId = "moduleId"
        static let ModuleName = "moduleName"
        static let SyncTimestamp = "syncTimestamp"
        static let Created = "created"
        static let Updated = "updated"
        static let Deleted = "deleted"
    }
    
    var moduleName: String = ""
    var moduleId: String = ""
    public internal(set) var syncTimestamp: NSDate?
    public internal(set) var created: [ContentInstance] = []
    public internal(set) var updated: [ContentInstance] = []
    public internal(set) var deleted: [String] = [] // Store only the ids that will be used for deletion
    
    private override init() {
        super.init()
    }
    
    init(data: [String: AnyObject]) {
        
        super.init()
        syncTimestamp = NSDate(timeIntervalSince1970: (data[Keys.SyncTimestamp] as? Double ?? 0)/1000)
        
        if let created = data[Keys.Created] as? [[String: AnyObject]] {
            let _ = created.map { self.created.append(ContentInstance.fromDictionary($0)) }
        }
        
        if let updated = data[Keys.Updated] as? [[String: AnyObject]] {
            let _ = updated.map { self.updated.append(ContentInstance.fromDictionary($0)) }
        }
        
        if let deleted = data[Keys.Deleted] as? [[String: AnyObject]] {
            let _ = deleted.map { self.deleted.append($0[ContentInstance.Keys.Id] as! String) }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        moduleName = aDecoder.decodeObjectForKey(Keys.ModuleName) as! String
        moduleId = aDecoder.decodeObjectForKey(Keys.ModuleId) as! String
        syncTimestamp = aDecoder.decodeObjectForKey(Keys.SyncTimestamp) as? NSDate
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(moduleName, forKey: Keys.ModuleName)
        aCoder.encodeObject(moduleId, forKey: Keys.ModuleId)
        aCoder.encodeObject(syncTimestamp, forKey: Keys.SyncTimestamp)
    }
}
