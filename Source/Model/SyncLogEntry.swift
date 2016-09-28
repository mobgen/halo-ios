//
//  SyncLog.swift
//  HaloSDK
//
//  Created by Borja on 23/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloSyncLogEntry)
public class SyncLogEntry: NSObject, NSCoding {

    struct Keys {
        static let ModuleId = "moduleId"
        static let ModuleName = "moduleName"
        static let SyncDate = "syncDate"
        static let Locale = "locale"
        static let Creations = "creations"
        static let Updates = "updates"
        static let Deletions = "deletions"
    }

    public internal(set) var moduleId: String?
    public internal(set) var moduleName: String?
    public internal(set) var syncDate: NSDate?
    public internal(set) var locale: Locale?
    public internal(set) var creations: Int = 0
    public internal(set) var updates: Int = 0
    public internal(set) var deletions: Int = 0

    public init(result: SyncResult) {
        moduleId = result.moduleId
        moduleName = result.moduleName
        syncDate = result.syncDate
        locale = result.locale
        creations = result.created.count
        updates = result.updated.count
        deletions = result.deleted.count
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {

        moduleId = aDecoder.decodeObjectForKey(Keys.ModuleId) as? String
        moduleName = aDecoder.decodeObjectForKey(Keys.ModuleName) as? String
        syncDate = aDecoder.decodeObjectForKey(Keys.SyncDate) as? NSDate

        if let loc = aDecoder.decodeObjectForKey(Keys.Locale) as? Int {
            locale = Locale(rawValue: loc)
        }

        creations = aDecoder.decodeIntegerForKey(Keys.Creations)
        updates = aDecoder.decodeIntegerForKey(Keys.Updates)
        deletions = aDecoder.decodeIntegerForKey(Keys.Deletions)

        super.init()
    }

    public func encodeWithCoder(aCoder: NSCoder) {

        aCoder.encodeObject(moduleId, forKey: Keys.ModuleId)
        aCoder.encodeObject(moduleName, forKey: Keys.ModuleName)
        aCoder.encodeObject(syncDate, forKey: Keys.SyncDate)
        aCoder.encodeObject(locale?.rawValue, forKey: Keys.Locale)

        if let loc = locale?.rawValue {
            aCoder.encodeObject(loc, forKey: Keys.Locale)
        }

        aCoder.encodeInteger(creations, forKey: Keys.Creations)
        aCoder.encodeInteger(updates, forKey: Keys.Updates)
        aCoder.encodeInteger(deletions, forKey: Keys.Deletions)

    }
}
