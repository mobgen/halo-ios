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

    open fileprivate(set) var locale: Locale?
    open fileprivate(set) var moduleName: String?
    open fileprivate(set) var moduleId: String = ""
    open fileprivate(set) var fromSync: Date?
    open fileprivate(set) var toSync: Date?

    open var body: [String: AnyObject] {
        var dict = [String: AnyObject]()

        dict[Keys.ModuleId] = moduleId as AnyObject?
        
        if let name = moduleName {
            dict[Keys.ModuleName] = name as AnyObject?
        }
        
        if let loc = locale {
            dict[Keys.Locale] = loc.description as AnyObject?
        }

        if let from = fromSync {
            dict[Keys.FromSync] = from.timeIntervalSince1970 * 1000 as AnyObject
        }

        if let to = toSync {
            dict[Keys.ToSync] = to.timeIntervalSince1970 * 1000 as AnyObject
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
    open func moduleName(name: String?) -> SyncQuery {
        self.moduleName = name
        return self
    }

    @discardableResult
    open func moduleId(id: String) -> SyncQuery {
        self.moduleId = id
        return self
    }
    
    @discardableResult
    open func locale(locale: Locale) -> SyncQuery {
        self.locale = locale
        return self
    }
    
    @discardableResult
    open func fromSync(date: Date?) -> SyncQuery {
        self.fromSync = date
        return self
    }
    
    @discardableResult
    open func toSync(date: Date?) -> SyncQuery {
        self.toSync = date
        return self
    }
}
