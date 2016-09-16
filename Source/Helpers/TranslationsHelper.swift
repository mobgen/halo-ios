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

    private var moduleName: String?
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

    public convenience init(moduleName: String, keyField: String, valueField: String) {
        self.init()
        self.moduleName = moduleName
        self.keyField = keyField
        self.valueField = valueField
    }

    public func locale(locale: Locale) -> TranslationsHelper {
        self.locale = locale
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

    public func getAllTexts() -> [String: String?] {

        return translationsMap
    }

    public func load() -> Void {

        if self.isLoading {
            return
        }

        if let locale = self.locale, moduleName = self.moduleName, keyField = self.keyField, valueField = self.valueField {

            self.isLoading = true
            self.translationsMap.removeAll()

            let syncQuery = SyncQuery().moduleName(moduleName).locale(locale)
            
            Manager.content.sync(syncQuery) { moduleName, error in
            
                self.isLoading = false
                
                if let _ = error {
                    return
                }
                
                if let instances = Manager.content.getSyncedInstances(moduleName) {
                    
                    let _ = instances.map { item in
                        if let key = item.values[keyField] as? String,
                            value = item.values[valueField] as? String {
                            
                            self.translationsMap.updateValue(value, forKey: key)
                        }
                    }
                    
                    let _ = self.completionHandlers.map { $0() }
                }
            }
        } else {
            NSLog("--- Missing parameter")
        }
    }

}
