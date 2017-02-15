//
//  HaloTranslations.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloTranslationsHelper)
open class TranslationsHelper: NSObject {

    fileprivate var moduleId: String = ""
    fileprivate var keyField: String?
    fileprivate var valueField: String?
    fileprivate var defaultText: String?
    fileprivate var loadingText: String?
    fileprivate var translationsMap: [String: String] = [:]
    fileprivate var isLoading: Bool = false
    fileprivate var syncQuery: SyncQuery!
    fileprivate var locale: Locale!
    
    fileprivate var completionHandlers: [(Error?) -> Void] = []

    fileprivate override init() {
        super.init()
    }

    public convenience init(moduleId: String, locale: Locale, keyField: String, valueField: String) {
        self.init()
        self.moduleId = moduleId
        self.locale = locale
        self.keyField = keyField
        self.valueField = valueField
        self.syncQuery = SyncQuery(moduleId: moduleId).locale(locale)
    }

    open func addCompletionHandler(handler: @escaping (Error?) -> Void) -> Void {
        completionHandlers.append(handler)
    }
    
    @discardableResult
    open func locale(_ locale: Locale) -> TranslationsHelper {
        self.locale = locale
        self.syncQuery.locale(locale)
        load()
        return self
    }

    @discardableResult
    open func defaultText(_ text: String) -> TranslationsHelper {
        self.defaultText = text
        return self
    }

    @discardableResult
    open func loadingText(_ text: String) -> TranslationsHelper {
        self.loadingText = text
        return self
    }
    
    open func getText(key: String, completionHandler handler: ((String?) -> Void)? = nil) -> Void {
        if self.isLoading {
            if let h = handler {
                self.completionHandlers.append { _ in
                    h(self.translationsMap[key])
                }
            }
            handler?(self.loadingText)
        } else {
            if let value = self.translationsMap[key] {
                handler?(value)
            } else {
                handler?(self.defaultText)
            }
        }
    }

    open func getTexts(keys: String...) -> [String: String?] {

        var values: [String: String?] = [:]

        keys.forEach { key in
            if let value = translationsMap[key] {
                values[key] = value
            } else {
                values[key] = self.defaultText
            }
        }

        return values

    }

    open func getAllTexts() -> [String: String] {
        return translationsMap
    }

    open func clearAllTexts() -> Void {
        translationsMap.removeAll()
        Manager.content.removeSyncedInstances(moduleId: moduleId)
    }
    
    open func load() -> Void {

        if isLoading {
            return
        }
    
        isLoading = true
        
        Manager.content.sync(query: syncQuery) { moduleId, error in
            self.processSyncResult(moduleId: moduleId, error: error)
            self.completionHandlers.forEach { $0(error) }
        }
    }
    
    fileprivate func processSyncResult(moduleId: String, error: HaloError?) {
        
        self.isLoading = false
        
        if let e = error {
            Manager.core.logMessage(e.description, level: .error)
            return
        }
        
        let instances = Manager.content.getSyncedInstances(moduleId: moduleId)
        
        if let keyField = self.keyField, let valueField = self.valueField {
            
            translationsMap.removeAll()
            
            instances.forEach { item in
                if let key = item.values[keyField] as? String,
                    let value = item.values[valueField] as? String {
                    self.translationsMap.updateValue(value, forKey: key)
                }
            }
        }
    }

}
