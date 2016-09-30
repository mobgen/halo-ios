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
    private var locale: Locale!
    
    private var completionHandlers: [(NSError?) -> Void] = []

    private override init() {
        super.init()
    }

    public convenience init(moduleId: String, locale: Locale, keyField: String, valueField: String) {
        self.init()
        self.moduleId = moduleId
        self.locale = locale
        self.keyField = keyField
        self.valueField = valueField
        self.syncQuery = SyncQuery(moduleId: moduleId).locale(locale: locale)
    }

    public func addCompletionHandler(handler handler: (NSError?) -> Void) -> Void {
        completionHandlers.append(handler)
    }
    
    public func locale(locale locale: Locale) -> TranslationsHelper {
        self.locale = locale
        self.syncQuery.locale(locale: locale)
        load()
        return self
    }

    public func defaultText(text text: String) -> TranslationsHelper {
        self.defaultText = text
        return self
    }

    public func loadingText(text text: String) -> TranslationsHelper {
        self.loadingText = text
        return self
    }
    
    public func getText(key key: String, completionHandler handler: ((String?) -> Void)? = nil) -> Void {
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

    public func getTexts(keys keys: String...) -> [String: String?] {

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
        
        Manager.content.sync(query: syncQuery) { moduleId, error in
            self.processSyncResult(moduleId: moduleId, error: error)
            self.completionHandlers.forEach { $0(error) }
        }
    }
    
    private func processSyncResult(moduleId moduleId: String, error: NSError?) {
        
        self.isLoading = false
        
        if let e = error {
            LogMessage(error: e).print()
            return
        }
        
        let instances = Manager.content.getSyncedInstances(moduleId)
        
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
