//
//  SyncQuery.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 14/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloSyncQuery)
public class SyncQuery: NSObject {

    struct Keys {
        static let ModuleId = "moduleId"
        static let ModuleName = "moduleName"
        static let Locale = "locale"
        static let FromSync = "fromSync"
        static let ToSync = "toSync"
    }

    public private(set) var locale: Locale?
    public private(set) var moduleName: String?
    public private(set) var moduleId: String = ""
    public private(set) var fromSync: NSDate?
    public private(set) var toSync: NSDate?

    public var body: [String: AnyObject] {
        var dict = [String: AnyObject]()

        dict[Keys.ModuleId] = moduleId
        
        if let name = moduleName {
            dict[Keys.ModuleName] = name
        }
        
        if let loc = locale {
            dict[Keys.Locale] = loc.description
        }

        if let from = fromSync {
            dict[Keys.FromSync] = from.timeIntervalSince1970 * 1000
        }

        if let to = toSync {
            dict[Keys.ToSync] = to.timeIntervalSince1970 * 1000
        }

        return dict
    }

    private override init() {
        super.init()
    }
    
    public init(moduleId: String) {
        super.init()
        self.moduleId = moduleId
    }
    
    public func moduleName(name name: String?) -> SyncQuery {
        self.moduleName = name
        return self
    }

    public func moduleId(id id: String) -> SyncQuery {
        self.moduleId = id
        return self
    }
    
    public func locale(locale locale: Locale) -> SyncQuery {
        self.locale = locale
        return self
    }
    
    public func fromSync(date date: NSDate?) -> SyncQuery {
        self.fromSync = date
        return self
    }
    
    public func toSync(date date: NSDate?) -> SyncQuery {
        self.toSync = date
        return self
    }
}
