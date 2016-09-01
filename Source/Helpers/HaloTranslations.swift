//
//  HaloTranslations.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc
public class HaloTranslations: NSObject {

    private var moduleId: String?
    private var keyField: String?
    private var valueField: String?
    private var defaultText: String?
    private var locale: Locale?
    private var translationsMap: [String: String] = [:]
    private var isLoading: Bool = false

    private override init() {
        super.init()
    }

    public convenience init(moduleId: String, keyField: String, valueField: String) {
        self.init()
        self.moduleId = moduleId
        self.keyField = keyField
        self.valueField = valueField
    }

    public func locale(locale: Locale) -> HaloTranslations {
        self.locale = locale
        return self
    }

    public func defaultText(text: String) -> HaloTranslations {
        self.defaultText = text
        return self
    }

    public func getText(key: String, completionHandler handler: ((String?) -> Void)?) -> Void {

        if translationsMap.isEmpty {
            self.load { success in
                if success {
                    handler?(self.translationsMap[key])
                } else {
                    handler?(nil)
                }
            }
        } else {
            handler?(self.translationsMap[key])
        }
    }

    public func getTexts(keys: String..., completionHandler handler: ([String?]? -> Void)?) -> Void {

        if translationsMap.isEmpty {
            self.load { success in
                if success {
                    let texts = keys.map { self.translationsMap[$0] }
                    handler?(texts)
                } else {
                    handler?(nil)
                }
            }
        } else {
            let texts = keys.map { translationsMap[$0] }
            handler?(texts)
        }
    }

    public func getAllTexts(handler: (([String]) -> Void)?) -> Void {



        handler?([])
    }

    private func load(completionHandler handler: ((Bool) -> Void)?) -> Void {

        if self.isLoading {
            handler?(true)
            return
        }

        if let locale = self.locale, keyField = self.keyField, valueField = self.valueField {

            var options = SearchOptions()
            options.skipPagination()
            options.setLocale(locale)

            self.isLoading = true

            try! Manager.content.getInstances(options).response { (response, result) in

                self.isLoading = false
                self.translationsMap.removeAll()

                switch result {
                case .Success(let data as [[String: AnyObject]], _):

                    let _ = data.map { item in
                        if let values = item["values"] as? [String: AnyObject],
                            key = values[keyField] as? String,
                            value = values[valueField] as? String {

                            self.translationsMap.updateValue(value, forKey: key)
                        }
                    }

                    handler?(true)
                case .Failure(let error):
                    LogMessage(error: error).print()
                    handler?(false)
                default:
                    handler?(false)
                }
            }
        } else {
            handler?(false)
        }
    }

}
