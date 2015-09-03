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

        let mgr = Halo.Manager.sharedInstance
//        var request: NSURLRequest?
//        var response: NSHTTPURLResponse?
//        var result: Result<AnyObject>?

        beforeSuite {
            mgr.launch()
            mgr.clientId = "testclientid"
            mgr.clientSecret = "testclientsecret"
        }

        afterEach {
            print("After suite")
            OHHTTPStubs.removeAllStubs()
        }

        describe("The core manager") {
            it("has been initialised properly") {
                expect(mgr).toNot(beNil())
            }
        }

        describe("The device extension") {
            it("provides the right model name") {
                expect(UIDevice.currentDevice().getModelName("iPad3,5") == "iPad 4").to(beTrue())
                expect(UIDevice.currentDevice().getModelName("Blah") == "Blah").to(beTrue())
            }
        }

        describe("The oauth process") {

            beforeEach {
                Router.token = nil
//                request = nil
//                response = nil
//                result = nil
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
//                            let fixture = OHPathForFile("module_list_success.json", self.dynamicType)
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
