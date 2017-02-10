//
//  MockTranslationsHelper.swift
//  Halo
//
//  Created by Miguel López on 27/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

@testable import Halo

class MockTranslationsHelper : TranslationsHelper {
    
    static let TestModuleId = "571f38b9bb7f372900a14cbc"
    static let TestLocale = Locale.spanishSpain
    static let TestKeyField = "testKeyField"
    static let TestValueField = "testValueField"
    static let TestDefaultText = "testDefaultText"
    static let TestLoadingText = "testLoadingText"
    
    class func createTranslationsHelper() -> TranslationsHelper {
        return TranslationsHelper(moduleId: TestModuleId, locale: TestLocale, keyField: TestKeyField, valueField: TestValueField)
    }
    
}
