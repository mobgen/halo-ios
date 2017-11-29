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

    fileprivate var moduleId: String?
    fileprivate var moduleName: String?
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
    
    public convenience init(moduleName: String, locale: Locale, keyField: String, valueField: String) {
        self.init()
        self.moduleName = moduleName
        self.locale = locale
        self.keyField = keyField
        self.valueField = valueField
        self.syncQuery = SyncQuery(moduleName: moduleName).locale(locale)
    }

    @objc(addCompletionHandler:)
    open func addCompletionHandler(handler: @escaping (Error?) -> Void) -> Void {
        completionHandlers.append(handler)
    }
    

    @discardableResult
    @objc(locale:)
    open func locale(_ locale: Locale) -> TranslationsHelper {
        self.locale = locale
        self.syncQuery.locale(locale)
        load()
        return self
    }

    @discardableResult
    @objc(defaultText:)
    open func defaultText(_ text: String) -> TranslationsHelper {
        self.defaultText = text
        return self
    }

    @discardableResult
    @objc(loadingText:)
    open func loadingText(_ text: String) -> TranslationsHelper {
        self.loadingText = text
        return self
    }
    
    @objc(getTextForKey:completionHandler:)
    open func getText(key: String, completionHandler handler: @escaping (String?) -> Void) -> Void {
        if self.isLoading {
                self.completionHandlers.append { _ in
                    handler(self.translationsMap[key])
                }
            handler(self.loadingText)
        } else {
            if let value = self.translationsMap[key] {
                handler(value)
            } else {
                handler(self.defaultText)
            }
        }
    }

    open func getTexts(keys: [String], completionHandler handler: @escaping ([String: String?]) -> Void) -> Void {

        if self.isLoading {
                self.completionHandlers.append { _ in
                    handler(self.getTexts(keys: keys))
                }
        } else {
            handler(self.getTexts(keys: keys))
        }
    }
    
    fileprivate func getTexts(keys: [String]) -> [String: String?] {
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

    open func getAllTexts(completionHandler handler: @escaping ([String: String?]) -> Void) -> Void {
        
        if self.isLoading {
            self.completionHandlers.append { _ in
                handler(self.translationsMap)
            }
        } else {
            handler(translationsMap)
        }
    }

    open func clearAllTexts() -> Void {
        translationsMap.removeAll()
        if let id = moduleId {
            Manager.content.removeSyncedInstances(moduleId: id)
        } else  if let name = moduleId {
            Manager.content.removeSyncedInstancesByName(moduleName: name)
        }
    }
    
    open func load() -> Void {

        if isLoading {
            return
        }
    
        isLoading = true
        if let id = moduleId {
            Manager.content.sync(query: syncQuery) { moduleId, error in
                self.processSyncResult(moduleId: id, error: error)
                self.completionHandlers.forEach { $0(error) }
            }
        } else if let name = moduleName {
            Manager.content.syncByName(query: syncQuery) { moduleName , error in
                self.processSyncResult(moduleName: name, error: error)
                self.completionHandlers.forEach { $0(error) }
            }
        }
    }
    
    fileprivate func processSyncResult(moduleId: String? = nil ,moduleName : String? = nil, error: HaloError?) {
        
        self.isLoading = false
        
        if let e = error {
            Manager.core.logMessage(e.description, level: .error)
            return
        }
        
        var instances : [ContentInstance]
        if let id = moduleId {
            instances = Manager.content.getSyncedInstances(moduleId: id)
            setTrasnlationsMap(instances: instances)
        } else if let name = moduleName {
            instances = Manager.content.getSyncedInstances(moduleId: name)
            setTrasnlationsMap(instances: instances)
        }
    }
    
    fileprivate func setTrasnlationsMap(instances : [ContentInstance]){
        
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
