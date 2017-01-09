//
//  SyncResult.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 15/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloSyncResult)
open class SyncResult: NSObject, NSCoding {
    
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
    open internal(set) var syncDate: Date?
    open internal(set) var created: [ContentInstance] = []
    open internal(set) var updated: [ContentInstance] = []
    open internal(set) var deleted: [String] = [] // Store only the ids that will be used for deletion
    open internal(set) var locale: Locale?
    
    fileprivate override init() {
        super.init()
    }
    
    init(data: [String: AnyObject]) {
        
        super.init()
        syncDate = Date(timeIntervalSince1970: (data[Keys.SyncDate] as? Double ?? 0)/1000)
        
        if let created = data[Keys.Created] as? [[String: AnyObject]] {
            created.forEach { self.created.append(ContentInstance.fromDictionary(dict: $0)) }
        }
        
        if let updated = data[Keys.Updated] as? [[String: AnyObject]] {
            updated.forEach { self.updated.append(ContentInstance.fromDictionary(dict: $0)) }
        }
        
        if let deleted = data[Keys.Deleted] as? [[String: AnyObject]] {
            deleted.forEach { self.deleted.append($0[ContentInstance.Keys.Id] as! String) }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        moduleName = aDecoder.decodeObject(forKey: Keys.ModuleName) as! String
        moduleId = aDecoder.decodeObject(forKey: Keys.ModuleId) as! String
        syncDate = aDecoder.decodeObject(forKey: Keys.SyncDate) as? Date
        locale = Locale(rawValue: aDecoder.decodeInteger(forKey: Keys.Locale))
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(moduleName, forKey: Keys.ModuleName)
        aCoder.encode(moduleId, forKey: Keys.ModuleId)
        aCoder.encode(syncDate, forKey: Keys.SyncDate)
        
        if let loc = locale?.rawValue {
            aCoder.encode(loc, forKey: Keys.Locale)
        }
    }
}
