//
//  TranslationHelpersSpec.swift
//  Halo
//
//  Created by Miguel López on 27/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class TranslationsHelperSpec : BaseSpec {
    
    override func spec() {
        super.spec()
        
        describe("A TranslationsHelper") {
            var translationsHelper: TranslationsHelper!
            
            beforeEach {
                Manager.core.appCredentials = Credentials(clientId: "halotestappclient", clientSecret: "halotestapppass")
                Manager.core.startup()
            }
            
            context("with a successful sync stub") {
                beforeEach {
                    stub(condition: isPath("/api/generalcontent/instance/sync")) { _ in
                        let filePath = OHPathForFile("full_sync.json", type(of: self))
                        return fixture(filePath: filePath!, status: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Successful sync stub"
                    
                    Manager.content.removeSyncedInstances(MockTranslationsHelper.TestModuleId)
                    Manager.content.clearSyncLog(MockTranslationsHelper.TestModuleId)
                    
                    translationsHelper = MockTranslationsHelper.createTranslationsHelper()
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
                }
            
                describe("its constructor method and getAllTexts method") {
                    beforeEach {
                        waitUntil(timeout: 3) { done in
                            translationsHelper.addCompletionHandler { (error) in
                                done()
                            }
                            translationsHelper.load()
                        }
                    }
                    
                    afterEach {
                        OHHTTPStubs.removeAllStubs()
                    }
                    
                    it("works") {
                        expect(translationsHelper).toNot(beNil())
                        let texts = translationsHelper.getAllTexts()
                        expect(texts.count).to(equal(1))
                    }
                }
                
                describe("its locale method") {
                    beforeEach {
                        waitUntil(timeout: 3) { done in
                            translationsHelper.addCompletionHandler { (error) in
                                done()
                            }
                            translationsHelper = translationsHelper.locale(locale: .englishUnitedStates)
                        }
                    }
                    
                    afterEach {
                        OHHTTPStubs.removeAllStubs()
                    }
                    
                    it("works") {
                        expect(translationsHelper).toNot(beNil())
                        let texts = translationsHelper.getAllTexts()
                        expect(texts.count).to(equal(1))
                    }
                }
                
                describe("its getText method") {
                    var valueResult: String?
                    
                    context("with an existing key") {
                        beforeEach {
                            waitUntil(timeout: 3) { done in
                                translationsHelper.addCompletionHandler { (error) in
                                    translationsHelper.getText(key: "key") { (result) in
                                        valueResult = result
                                        done()
                                    }
                                }
                                translationsHelper.load()
                            }
                        }
                        
                        it("works") {
                            expect(valueResult).toNot(beNil())
                            expect(valueResult).to(equal("value"))
                        }
                    }
                    
                    context("with a non existing key") {
                        beforeEach {
                            waitUntil(timeout: 3) { done in
                                translationsHelper
                                    .defaultText(text: MockTranslationsHelper.TestDefaultText)
                                    .addCompletionHandler { (error) in
                                    translationsHelper.getText(key: "invalid key") { (result) in
                                        valueResult = result
                                        done()
                                    }
                                }
                                translationsHelper.load()
                            }
                        }
                        
                        it("returns default text") {
                            expect(valueResult).toNot(beNil())
                            expect(valueResult).to(equal(MockTranslationsHelper.TestDefaultText))
                        }
                    }
                }
                
                describe("its getTexts method") {
                    context("with an existing key") {
                        beforeEach {
                            waitUntil(timeout: 3) { done in
                                translationsHelper.addCompletionHandler { (error) in
                                    done()
                                }
                                translationsHelper.load()
                            }
                        }
                        
                        it("works") {
                            let texts = translationsHelper.getTexts(keys: "key")
                            expect(texts["key"]!!).to(equal("value"))
                        }
                    }
                    
                    context("with a non existing key") {
                        beforeEach {
                            waitUntil(timeout: 3) { done in
                                translationsHelper
                                    .defaultText(text: MockTranslationsHelper.TestDefaultText)
                                    .addCompletionHandler { (error) in
                                        done()
                                    }
                                translationsHelper.load()
                            }
                        }
                        
                        it("works") {
                            let texts = translationsHelper.getTexts(keys: "invalid key")
                            expect(texts["invalid key"]!!).to(equal(MockTranslationsHelper.TestDefaultText))
                        }
                    }
                }
                
                describe("its clearAllTexts method") {
                    beforeEach {
                        waitUntil(timeout: 3) { done in
                            translationsHelper.addCompletionHandler { (error) in
                                translationsHelper.clearAllTexts()
                                done()
                            }
                            translationsHelper.load()
                        }
                    }
                    
                    it("works") {
                        expect(translationsHelper).toNot(beNil())
                        let texts = translationsHelper.getAllTexts()
                        expect(texts.count).to(equal(0))
                    }
                }
            }
            
            context("with a failed sync stub") {
                beforeEach {
                    stub(condition: isPath("/api/generalcontent/instance/sync")) { _ in
                        let filePath = OHPathForFile("oauth_failure.json", type(of: self))
                        return fixture(filePath: filePath!, status: 400, headers: ["Content-Type": "application/json"])
                    }.name = "Successful sync stub"
                    
                    Manager.content.removeSyncedInstances(MockTranslationsHelper.TestModuleId)
                    Manager.content.clearSyncLog(MockTranslationsHelper.TestModuleId)
                    
                    translationsHelper = MockTranslationsHelper.createTranslationsHelper()
                }
                
                describe("load method") {
                    var error: NSError?
                    
                    beforeEach {
                        waitUntil(timeout: 3) { done in
                            translationsHelper.addCompletionHandler { (errorResponse) in
                                error = errorResponse
                                done()
                            }
                            translationsHelper.load()
                        }
                    }
                    
                    it("returns an error") {
                        expect(error).toNot(beNil())
                    }
                }
            }
            
            xcontext("while already loading another sync") {
                beforeEach {
                    stub(condition: isPath("/api/generalcontent/instance/sync")) { _ in
                        let filePath = OHPathForFile("full_sync.json", type(of: self))
                        return fixture(filePath: filePath!, status: 200, headers: ["Content-Type": "application/json"]).requestTime(1, responseTime: 3)
                    }.name = "Successful sync stub with 1 second of request time and 3 seconds of response time"
                    
                    Manager.content.removeSyncedInstances(MockTranslationsHelper.TestModuleId)
                    Manager.content.clearSyncLog(MockTranslationsHelper.TestModuleId)
                    
                    translationsHelper = MockTranslationsHelper.createTranslationsHelper()
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
                }
                
                describe("its getText method") {
                    var result: String?
                    
                    beforeEach {
                        waitUntil(timeout: 10) { done in
                            translationsHelper.addCompletionHandler { _ in
                                done()
                            }
                            translationsHelper
                                .loadingText(text: MockTranslationsHelper.TestLoadingText)
                                .load()
                        }
                        
                        waitUntil(timeout: 3) { done in
                            translationsHelper.getText(key: "key") { resultResponse in
                                result = resultResponse
                                done()
                            }
                        }
                    }
                    
                    afterEach {
                        OHHTTPStubs.removeAllStubs()
                    }
                    
                    it("returns the loadingText") {
                        expect(result).toNot(beNil())
                        expect(result).to(equal(MockTranslationsHelper.TestLoadingText))
                    }
                }
            }
        }
    }
    
}
