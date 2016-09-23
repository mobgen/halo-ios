//
//  HaloTranslations.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloTranslationsHelper)
public class TranslationsHelper: NSObject {

    private var moduleId: String = ""
    private var keyField: String?
    private var valueField: String?
    private var defaultText: String?
    private var loadingText: String?
    private var translationsMap: [String: String] = [:]
    private var isLoading: Bool = false
    private var syncQuery: SyncQuery!
    private var locale: Locale?
    
    private var completionHandlers: [() -> Void] = []

    private override init() {
        super.init()
    }

    public convenience init(moduleId: String, locale: Locale, keyField: String, valueField: String) {
        self.init()
        self.moduleId = moduleId
        self.locale = locale
        self.keyField = keyField
        self.valueField = valueField
        self.syncQuery = SyncQuery(moduleId: moduleId)
    }

    public func addCompletionHandler(handler: () -> Void) -> Void {
        completionHandlers.append(handler)
    }
    
    public func locale(locale: Locale) -> TranslationsHelper {
        self.locale = locale
        load()
        return self
    }

    public func defaultText(text: String) -> TranslationsHelper {
        self.defaultText = text
        return self
    }

    public func loadingText(text: String) -> TranslationsHelper {
        self.loadingText = text
        return self
    }
    
    public func getText(key: String, completionHandler handler: ((String?) -> Void)? = nil) -> Void {
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

    public func getTexts(keys: String...) -> [String: String?] {

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

    public func getAllTexts() -> [String: String] {
        return translationsMap
    }

    public func clearAllTexts() -> Void {
        translationsMap.removeAll()
        Manager.content.removeSyncedInstances(moduleId)
    }
    
    public func load() -> Void {

        if isLoading {
            return
        }
    
        isLoading = true
        translationsMap.removeAll()
        
        Manager.content.sync(syncQuery) { moduleId, error in
            self.processSyncResult(moduleId, error: error)
            self.completionHandlers.forEach { $0() }
        }
        
    }
    
    private func processSyncResult(moduleId: String, error: NSError?) {
        
        self.isLoading = false
        
        if error != nil {
            completionHandlers.forEach { $0() }
            return
        }
        
        if let instances = Manager.content.getSyncedInstances(moduleId), let keyField = self.keyField, let valueField = self.valueField {
            
            instances.forEach { item in
                if let key = item.values[keyField] as? String,
                    let value = item.values[valueField] as? String {
                    
                    self.translationsMap.updateValue(value, forKey: key)
                }
            }
        }
    }

}
