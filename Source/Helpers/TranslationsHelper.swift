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
    private var locale: Locale?
    private var translationsMap: [String: String] = [:]
    private var isLoading: Bool = false

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
    }

    public func locale(locale: Locale, completionHandler handler: ((String, NSError?) -> Void)? = nil) -> TranslationsHelper {
        self.locale = locale
        self.clearAllTexts()
        load(completionHandler: handler)
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
    
    public func getText(key: String, completionHandler handler: ((String?) -> Void)?) -> Void {
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

        let _ = keys.map { key in
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
        Manager.content.removeSyncedInstances(self.moduleId)
    }
    
    public func load(completionHandler handler: ((String, NSError?) -> Void)? = nil) -> Void {

        if self.isLoading {
            return
        }

        if let locale = self.locale, keyField = self.keyField, let valueField = self.valueField {

            self.isLoading = true
            self.translationsMap.removeAll()

            let syncQuery = SyncQuery(moduleId: moduleId).locale(locale)
            
            Manager.content.sync(syncQuery) { moduleId, error in
            
                self.isLoading = false
                
                if let e = error {
                    handler?(moduleId, e)
                    let _ = self.completionHandlers.map { $0() }
                    return
                }
                
                if let instances = Manager.content.getSyncedInstances(moduleId) {
                    
                    let _ = instances.map { item in
                        if let key = item.values[keyField] as? String,
                            let value = item.values[valueField] as? String {
                            
                            self.translationsMap.updateValue(value, forKey: key)
                        }
                    }
                }
                
                handler?(moduleId, error)
                let _ = self.completionHandlers.map { $0() }
            }
        } else {
            LogMessage("Missing parameter for the translations sync request", level: .Error).print()
        }
    }

}
