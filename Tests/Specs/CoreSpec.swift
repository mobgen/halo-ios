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
        
        beforeSuite {
            mgr.appCredentials = Credentials(clientId: "halotestappclient", clientSecret: "halotestapppass")
            mgr.logLevel = .info
        }
        
        describe("The core manager") {
            
            afterEach {
                OHHTTPStubs.removeAllStubs()
            }
            
            context("when the startup process succeeds") {
            
                beforeEach {
                    stub(condition: pathStartsWith("/api/segmentation/appuser")) { _ in
                        let filePath = OHPathForFile("segmentation_appuser_success.json", type(of: self))
                        return fixture(filePath: filePath!, status: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Successful appuser stub"
                }
                
                it("has been initialised properly") {
                    expect(mgr).toNot(beNil())
                }
                
                it("starts properly") {
                    waitUntil { done in
                        mgr.startup { success in
                            done()
                        }
                    }
                    
                    expect(mgr.device).toNot(beNil())
                }
            }
            
            context("when the authentication returns a 401 error") {
                
                beforeEach {
                    mgr.startup()
                    
                    stub(condition: pathStartsWith("/api/oauth/token")) { _ in
                        let filePath = OHPathForFile("oauth_failure.json", type(of: self))
                        return fixture(filePath: filePath!, status: 401, headers: ["Content-Type": "application/json"])
                    }.name = "Failed oauth stub"
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
                expect(mgr.frameworkVersion).to(equal("2.0.1"))
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
                
                it("fails") {
                    expect(Halo.Router.appToken).to(beNil())
                }
            }
        }
    }
}
