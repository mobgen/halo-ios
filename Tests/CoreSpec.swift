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
import Alamofire
@testable import Halo

class CoreSpec: QuickSpec {

    override func spec() {

        // Swift
        OHHTTPStubs.onStubActivation() { request, stub in
            NSLog("\(request.URL!) stubbed by \(stub.name).")
        }
        
        let mgr = Halo.Manager.sharedInstance

        beforeSuite {
            mgr.launch()
            mgr.clientId = "testclientid"
            mgr.clientSecret = "testclientsecret"
        }

        afterSuite {
            NSLog("After suite")
            //OHHTTPStubs.removeAllStubs()
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
                    OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.path! == "/api/oauth/token"
                        }, withStubResponse: { _ in
                            let fixture = OHPathForFile("oauth_success.json", self.dynamicType)
                            return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                    })

                    waitUntil { done in
                        mgr.net.refreshToken { (req, resp, res) -> Void in
                            done()
                        }
                    }
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
                    OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.path! == "/api/oauth/token"
                        }, withStubResponse: { _ in
                            let fixture = OHPathForFile("oauth_failure.json", self.dynamicType)
                            return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 401, headers: ["Content-Type": "application/json"])
                    })

                    waitUntil { done in
                        mgr.net.refreshToken { (req, resp, res) -> Void in
                            done()
                        }
                    }
                }

                it("fails") {
                    expect(Router.token).to(beNil())
                }
            }
        }

        describe("A full request cycle") {
            
            var counter = 0
            var result: Alamofire.Result<[Module]>?
            
            beforeEach {
                OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.path! == "/api/oauth/token"
                    }, withStubResponse: { _ in
                        counter++
                        let fixture = OHPathForFile("oauth_success.json", self.dynamicType)
                        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                })
                
                OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.path! == "/api/authentication/module/list"
                    }, withStubResponse: { _ in
                        let fixture = OHPathForFile("module_list_success.json", self.dynamicType)
                        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: counter > 0 ? 200 : 401, headers: ["Content-Type": "application/json"])
                })
                
                waitUntil(timeout: 5) { done in
                    mgr.getModules { result = $0; done() }
                }
                
            }
            
            afterEach {
                result = nil
            }
            
            it("works") {
                expect(result?.error).to(beNil())
                expect(result?.value).toNot(beNil())
            }
            
        }
        
        describe("Requesting the module list") {

            var result: Alamofire.Result<[Module]>?

            context("with a valid response") {

                beforeEach {
                    OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.path! == "/api/authentication/module/list"
                        }, withStubResponse: { _ in
                            let fixture = OHPathForFile("module_list_success.json", self.dynamicType)
                            return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                    })

                    waitUntil { done in
                        mgr.getModules { result = $0; done() }
                    }
                }
                
                afterEach {
                    result = nil
                }
                
                it("succeeds") {
                    expect(result?.error).to(beNil())
                }
                
            }

            context("with an invalid response") {

                beforeEach {
                    OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.path! == "/api/authentication/module/list"
                        }, withStubResponse: { _ in
                            return OHHTTPStubsResponse(JSONObject: [:], statusCode: 400, headers: ["Content-Type": "application/json"])
                    })

                    waitUntil { done in
                        mgr.getModules { result = $0; done() }
                    }
                }

                afterEach {
                    result = nil
                }

                it("fails") {
                    expect(result?.error).toNot(beNil());
                }
            }
            
        }

    }
    
}
