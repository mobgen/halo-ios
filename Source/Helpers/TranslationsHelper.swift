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

    private var moduleId: String?
    private var keyField: String?
    private var valueField: String?
    private var defaultText: String?
    private var locale: Locale?
    private var translationsMap: [String: String] = [:]
    private var isLoading: Bool = false

    private var completionHandlers: [() -> Void] = []

    private override init() {
        super.init()
    }

    public convenience init(moduleId: String, keyField: String, valueField: String) {
        self.init()
        self.moduleId = moduleId
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

    public func getText(key: String, completionHandler handler: ((String?) -> Void)?) -> Void {
        if self.isLoading {
            if let h = handler {
                self.completionHandlers.append {
                    h(self.translationsMap[key])
                }
            }
            handler?(self.defaultText)
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

    public func load(completionHandler handler: ((Bool) -> Void)?) -> Void {

        if self.isLoading {
            handler?(false)
            return
        }

        if let locale = self.locale, moduleId = self.moduleId, keyField = self.keyField, valueField = self.valueField {

            let query = SearchQuery().skipPagination().moduleIds([moduleId]).locale(locale)

            self.isLoading = true
            self.translationsMap.removeAll()

            Manager.content.search(query) { (response, result) in

                self.isLoading = false

                switch result {
                case .Success(let res, _):

                    let _ = res?.instances.map { item in
                        if let key = item.values[keyField] as? String,
                            value = item.values[valueField] as? String {

                            self.translationsMap.updateValue(value, forKey: key)
                        }
                    }

                    handler?(true)

                    // Execute all the pending completion handlers
                    let _ = self.completionHandlers.map { $0() }
                    self.completionHandlers.removeAll()

                case .Failure(let error):
                    LogMessage(error: error).print()
                    handler?(false)
                }
            }
        } else {
            handler?(false)
        }
    }

}
