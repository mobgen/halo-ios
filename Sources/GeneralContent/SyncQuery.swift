//
//  SyncQuery.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 14/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloSyncQuery)
open class SyncQuery: NSObject {

    struct Keys {
        static let ModuleId = "moduleId"
        static let ModuleName = "moduleName"
        static let Locale = "locale"
        static let FromSync = "fromSync"
        static let ToSync = "toSync"
    }

    open fileprivate(set) var locale: Locale? = Locale(locale: NSLocale.preferredLanguages[0])
    open fileprivate(set) var moduleName: String?
    open fileprivate(set) var moduleId: String = ""
    open fileprivate(set) var fromSync: Date?
    open fileprivate(set) var toSync: Date?

    open var body: [String: Any] {
        var dict = [String: Any]()

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

    fileprivate override init() {
        super.init()
    }
    
    public init(moduleId: String) {
        super.init()
        self.moduleId = moduleId
    }
    
    @discardableResult
    open func moduleName(_ name: String?) -> SyncQuery {
        self.moduleName = name
        return self
    }

    @discardableResult
    open func moduleId(_ id: String) -> SyncQuery {
        self.moduleId = id
        return self
    }
    
    @discardableResult
    open func locale(_ locale: Locale) -> SyncQuery {
        self.locale = locale
        return self
    }
    
    @discardableResult
    open func fromSync(_ date: Date?) -> SyncQuery {
        self.fromSync = date
        return self
    }
    
    @discardableResult
    open func toSync(_ date: Date?) -> SyncQuery {
        self.toSync = date
        return self
    }
}
