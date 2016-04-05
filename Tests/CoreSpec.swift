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

class CoreSpec: QuickSpec {
    
    override func spec() {
        
        // Swift
        OHHTTPStubs.onStubActivation() { request, stub in
            if let url = request.URL, name = stub.name {
                print("\(url) stubbed by \"\(name).\"")
            }
        }
        
        let mgr = Halo.Manager.core
        
        beforeSuite {
            mgr.appCredentials = Credentials(clientId: "halotestappclient", clientSecret: "halotestapppass")
            mgr.setEnvironment(.Stage)
        }
        
        afterSuite {
            NSLog("After suite")
            OHHTTPStubs.removeAllStubs()
        }
        
        describe("The core manager") {
            it("has been initialised properly") {
                expect(mgr).toNot(beNil())
            }
        }
        
        describe("The oauth process") {
            
            beforeEach {
                Router.token = nil
            }
            
            context("with the right credentials") {
                
                beforeEach {
                    stub(isPath("/api/oauth/token")) { (request) -> OHHTTPStubsResponse in
                        let fixture = OHPathForFile("oauth_success.json", self.dynamicType)
                        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Successful OAuth stub"
                    
                    waitUntil { done in
                        Halo.Manager.network.refreshToken { (response, result) in
                            done()
                        }
                    }
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
                }
                
                it("succeeds") {
                    expect(Router.token).toNot(beNil())
                }
                
                it("retrieves a valid token") {
                    expect(Router.token?.isValid()).to(beTrue())
                    expect(Router.token?.isExpired()).to(beFalse())
                }
                
            }
            
            context("with the wrong credentials") {
                
                beforeEach {
                    stub(isPath("/api/oauth/token")) { (request) -> OHHTTPStubsResponse in
                        let fixture = OHPathForFile("oauth_failure.json", self.dynamicType)
                        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 403, headers: ["Content-Type": "application/json"])
                    }.name = "Failed OAuth stub"
                                        
                    waitUntil { done in
                        Halo.Manager.network.refreshToken { (response, result) in
                            done()
                        }
                    }
                }
                
                it("fails") {
                    expect(Router.token).to(beNil())
                }
            }
        }
    }
}
