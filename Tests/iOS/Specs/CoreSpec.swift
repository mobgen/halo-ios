//
//  HaloCoreTests.swift
//  HaloCoreTests
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class CoreSpec: BaseSpec {
    
    override func spec() {
        
        super.spec()
        
        let mgr = Halo.Manager.core
        
        describe("The core manager") {
            
            beforeEach {
                mgr.appCredentials = Credentials(clientId: "halotestappclient", clientSecret: "halotestapppass")
                mgr.logLevel = .info
            }
            
            context("when setting a .none defaultOfflinePolicy") {
                beforeEach {
                    mgr.defaultOfflinePolicy = .none
                }
                
                it("set DataProviderManager.online as the dataProvider") {
                    expect(mgr.dataProvider).to(be(DataProviderManager.online))
                }
            }
            
            context("when setting a .loadAndStoreLocalData defaultOfflinePolicy") {
                beforeEach {
                    mgr.defaultOfflinePolicy = .loadAndStoreLocalData
                }
                
                afterEach {
                    mgr.defaultOfflinePolicy = .none
                }
                
                it("set DataProviderManager.onlineOffline as the dataProvider") {
                    expect(mgr.dataProvider).to(be(DataProviderManager.onlineOffline))
                }
            }
            
            context("when setting a .returnLocalDataDontLoad defaultOfflinePolicy") {
                beforeEach {
                    mgr.defaultOfflinePolicy = .returnLocalDataDontLoad
                }
                
                afterEach {
                    mgr.defaultOfflinePolicy = .none
                }
                
                it("set DataProviderManager.offline as the dataProvider") {
                    expect(mgr.dataProvider).to(be(DataProviderManager.offline))
                }
            }
            
            context("when the startup process succeeds") {
            
                beforeEach {
                    stub(condition: pathStartsWith("/api/segmentation/appuser")) { _ in
                        let filePath = OHPathForFile("segmentation_appuser_success.json", type(of: self))
                        return fixture(filePath: filePath!, status: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Successful appuser stub"
                    
                    waitUntil { done in
                        mgr.startup { success in
                            done()
                        }
                    }
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
                    
                    Router.appToken = nil
                    Router.userToken = nil
                }
                
                it("has been initialised properly") {
                    expect(mgr).toNot(beNil())
                }
                
                it("starts properly") {
                    expect(mgr.device).toNot(beNil())
                }
            }
            
            context("when the authentication returns a 401 error") {
                
                beforeEach {
                    stub(condition: pathStartsWith("/api/oauth/token")) { _ in
                        let filePath = OHPathForFile("oauth_failure.json", type(of: self))
                        return fixture(filePath: filePath!, status: 401, headers: ["Content-Type": "application/json"])
                    }.name = "Failed oauth stub"
                    
                    mgr.startup()
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
                    
                    Router.appToken = nil
                    Router.userToken = nil
                }
                
                it("returns an error") {
                    var res: Result<Token>?
                    waitUntil { done in
                        mgr.authenticate(authMode: .app) { (response, result) in
                            res = result
                            done()
                        }
                    }
                    
                    expect(res).toNot(beNil())
                    switch res! {
                    case .success(_, _):
                        XCTFail("Expected Failure, got<\(res)")
                        break
                    default:
                        break
                    }
                }
                
            }
            
            context("when saving the user fails") {
                
                beforeEach {
                    stub(condition: pathStartsWith("/api/segmentation/appuser")) { _ in
                        let filePath = OHPathForFile("segmentation_appuser_failure.json", type(of: self))
                        return fixture(filePath: filePath!, status: 400, headers: ["Content-Type": "application/json"])
                    }.name = "Failed appuser stub"
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
                }
                
                it("user has not changed") {
                    
                    let oldDevice = mgr.device
                    
                    waitUntil { done in
                        mgr.saveDevice { _ in
                            done()
                        }
                    }
                    
                    expect(mgr.device).to(be(oldDevice))
                }
            }
        }
        
        describe("Framework version") {
            it("is correct") {
                expect(mgr.frameworkVersion).to(equal("2.2"))
            }
        }
        
        describe("Registering an addon") {
            
            var addon: Addon?
            
            beforeEach {
                addon = DummyAddon()
                mgr.registerAddon(addon: addon!)
            }
            
            it("succeeds") {
                expect(mgr.addons.count).to(equal(1))
                expect(mgr.addons.first).to(be(addon))
            }
        }
        
        describe("The oauth process") {
            
            beforeEach {
                Halo.Router.appToken = nil
                Halo.Router.userToken = nil
            }
            
            afterEach {
                OHHTTPStubs.removeAllStubs()
            }
            
            context("with the right credentials") {
                
                beforeEach {
                    stub(condition: isPath("/api/oauth/token")) { _ in
                        let stubPath = OHPathForFile("oauth_success.json", type(of: self))
                        return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
                    }.name = "Successful OAuth stub"
                    
                    waitUntil { done in
                        Halo.Manager.network.authenticate(mode: .app) { _ in
                            done()
                        }
                    }
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
                }
                
                it("succeeds") {
                    expect(Halo.Router.appToken).toNot(beNil())
                }
                
                it("retrieves a valid token") {
                    expect(Halo.Router.appToken?.isValid()).to(beTrue())
                    expect(Halo.Router.appToken?.isExpired()).to(beFalse())
                }
                
            }
            
            context("with the wrong credentials") {
                
                beforeEach {
                    stub(condition: isPath("/api/oauth/token")) { _ in
                        let stubPath = OHPathForFile("oauth_failure.json", type(of: self))
                        return fixture(filePath: stubPath!, status: 401, headers: ["Content-Type":"application/json"])
                    }.name = "Failed OAuth stub"
                                        
                    waitUntil { done in
                        Halo.Manager.network.authenticate(mode: .app) { _ in
                            done()
                        }
                    }
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
                }
                
                it("fails") {
                    expect(Halo.Router.appToken).to(beNil())
                }
            }
        }
    }
}
