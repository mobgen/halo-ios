//
//  SyncLog.swift
//  HaloSDK
//
//  Created by Borja on 23/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloSyncLogEntry)
open class SyncLogEntry: NSObject, NSCoding {

    struct Keys {
        static let ModuleId = "moduleId"
        static let ModuleName = "moduleName"
        static let SyncDate = "syncDate"
        static let Locale = "locale"
        static let Creations = "creations"
        static let Updates = "updates"
        static let Deletions = "deletions"
    }

    open internal(set) var moduleId: String?
    open internal(set) var moduleName: String?
    open internal(set) var syncDate: Date?
    open internal(set) var locale: Locale? = Manager.content.defaultLocale
    open internal(set) var creations: Int = 0
    open internal(set) var updates: Int = 0
    open internal(set) var deletions: Int = 0

    public init(result: SyncResult) {
        moduleId = result.moduleId
        moduleName = result.moduleName
        syncDate = result.syncDate as Date?
        locale = result.locale
        creations = result.created.count
        updates = result.updated.count
        deletions = result.deleted.count
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {

        moduleId = aDecoder.decodeObject(forKey: Keys.ModuleId) as? String
        moduleName = aDecoder.decodeObject(forKey: Keys.ModuleName) as? String
        syncDate = aDecoder.decodeObject(forKey: Keys.SyncDate) as? Date
        
        if let loc = aDecoder.decodeObject(forKey: Keys.Locale) as? Int {
            locale = Locale(rawValue: loc)
        }

        creations = aDecoder.decodeInteger(forKey: Keys.Creations)
        updates = aDecoder.decodeInteger(forKey: Keys.Updates)
        deletions = aDecoder.decodeInteger(forKey: Keys.Deletions)

        super.init()
    }

    open func encode(with aCoder: NSCoder) {

        aCoder.encode(moduleId, forKey: Keys.ModuleId)
        aCoder.encode(moduleName, forKey: Keys.ModuleName)
        aCoder.encode(syncDate, forKey: Keys.SyncDate)
        
        if let loc = locale?.rawValue {
            aCoder.encode(loc, forKey: Keys.Locale)
        }

        aCoder.encode(creations, forKey: Keys.Creations)
        aCoder.encode(updates, forKey: Keys.Updates)
        aCoder.encode(deletions, forKey: Keys.Deletions)

    }
}
