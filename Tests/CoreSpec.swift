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
        
        let mgr = Halo.Manager.core
        
        beforeSuite {
            mgr.appCredentials = Credentials(clientId: "halotestappclient", clientSecret: "halotestapppass")
            mgr.setEnvironment(.Stage)
        }
        
        describe("The core manager") {
            it("has been initialised properly") {
                expect(mgr).toNot(beNil())
            }
        }
        
        describe("Framework version") {
            it("is correct") {
                expect(mgr.frameworkVersion).to(equal("2.0.0"))
            }
        }
        
        describe("Registering an addon") {
            
//            class DummyAddon: Addon {
//                
//            }
            
            beforeEach {
                
            }
            
            it("succeeds") {
                
            }
        }
        
        describe("The oauth process") {
            
            beforeEach {
                Halo.Router.appToken = nil
                Halo.Router.userToken = nil
            }
            
            context("with the right credentials") {
                
                beforeEach {
                    stub(isPath("/api/oauth/token")) { (request) -> OHHTTPStubsResponse in
                        let fixture = OHPathForFile("oauth_success.json", self.dynamicType)
                        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Successful OAuth stub"
                    
                    waitUntil { done in
                        Halo.Manager.network.authenticate(.App) { (response, result) in
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
                    stub(isPath("/api/oauth/token")) { (request) -> OHHTTPStubsResponse in
                        let fixture = OHPathForFile("oauth_failure.json", self.dynamicType)
                        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 403, headers: ["Content-Type": "application/json"])
                    }.name = "Failed OAuth stub"
                                        
                    waitUntil { done in
                        Halo.Manager.network.authenticate(.App) { (response, result) in
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
