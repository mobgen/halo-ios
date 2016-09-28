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
        static let SyncDate = "syncTimestamp"
        static let Created = "created"
        static let Updated = "updated"
        static let Deleted = "deleted"
        static let Locale = "locale"
    }
    
    var moduleName: String = ""
    var moduleId: String = ""
    public internal(set) var syncDate: NSDate?
    public internal(set) var created: [ContentInstance] = []
    public internal(set) var updated: [ContentInstance] = []
    public internal(set) var deleted: [String] = [] // Store only the ids that will be used for deletion
    public internal(set) var locale: Locale?
    
    private override init() {
        super.init()
    }
    
    init(data: [String: AnyObject]) {
        
        super.init()
        syncDate = NSDate(timeIntervalSince1970: (data[Keys.SyncDate] as? Double ?? 0)/1000)
        
        if let created = data[Keys.Created] as? [[String: AnyObject]] {
            created.forEach { self.created.append(ContentInstance.fromDictionary($0)) }
        }
        
        if let updated = data[Keys.Updated] as? [[String: AnyObject]] {
            updated.forEach { self.updated.append(ContentInstance.fromDictionary($0)) }
        }
        
        if let deleted = data[Keys.Deleted] as? [[String: AnyObject]] {
            deleted.forEach { self.deleted.append($0[ContentInstance.Keys.Id] as! String) }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        moduleName = aDecoder.decodeObjectForKey(Keys.ModuleName) as! String
        moduleId = aDecoder.decodeObjectForKey(Keys.ModuleId) as! String
        syncDate = aDecoder.decodeObjectForKey(Keys.SyncDate) as? NSDate
        
        if let loc = aDecoder.decodeObjectForKey(Keys.Locale) as? Int {
            locale = Locale(rawValue: loc)
        }
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(moduleName, forKey: Keys.ModuleName)
        aCoder.encodeObject(moduleId, forKey: Keys.ModuleId)
        aCoder.encodeObject(syncDate, forKey: Keys.SyncDate)
        
        if let loc = locale?.rawValue {
            aCoder.encodeObject(loc, forKey: Keys.Locale)
        }
    }
}
