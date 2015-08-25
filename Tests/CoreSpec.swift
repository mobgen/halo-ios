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

        beforeSuite {
            mgr.launch()
            mgr.net.clientId = "testclientid"
            mgr.net.clientSecret = "testclientsecret"
        }

        afterSuite {
            print("After suite")
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
                    OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> ObjCBool in
                        return ObjCBool(request.URL!.path! == "/api/oauth/token")
                        }, withStubResponse: { _ in
                            let fixture = OHPathForFile("oauth_success.json", self.dynamicType)
                            return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                    })

                    waitUntil { done in
                        mgr.net.refreshToken {
                            done()
                        }
                    }
                }

                it("succeeds") {
                    expect(Router.token).toNot(beNil())
                }

            }

            context("with the wrong credentials") {

                beforeEach {
                    OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> ObjCBool in
                        return ObjCBool(request.URL!.path! == "/api/oauth/token")
                        }, withStubResponse: { _ in
                            let fixture = OHPathForFile("oauth_failure.json", self.dynamicType)
                            return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 403, headers: ["Content-Type": "application/json"])
                    })
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
                    OHHTTPStubs.stubRequestsPassingTest({ ObjCBool($0.URL!.path! == "/api/authentication/module/list")
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

        }
    }

}
