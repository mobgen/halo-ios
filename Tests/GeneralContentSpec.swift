//
//  GeneralContentSpec.swift
//  HaloSDK
//
//  Created by Borja on 04/09/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
import Alamofire
@testable import Halo

class GeneralContentSpec : QuickSpec {

    override func spec() {

        let mgr = Halo.Manager.sharedInstance

        describe("Requesting the list of GC instances") {

            var result: Alamofire.Result<[GeneralContentInstance]>?

            context("with a valid response") {

                beforeEach {
                    OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.path! == "/api/generalcontent/instance/list"
                        }, withStubResponse: { _ in
                            let fixture = OHPathForFile("instance_list_success.json", self.dynamicType)
                            return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                    })

                    waitUntil { done in
                        mgr.generalContent.getInstancesFromObjC("dummy", success: { (userData) -> Void in
                            result = .Success(userData)
                            done()
                            }, failure: nil)
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
                    OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.path! == "/api/generalcontent/instance/list"
                        }, withStubResponse: { _ in
                            return OHHTTPStubsResponse(JSONObject: [:], statusCode: 400, headers: ["Content-Type": "application/json"])
                    })

                    waitUntil { done in
                        mgr.generalContent.getInstancesFromObjC("dummy", success: nil, failure: { (error) -> Void in
                            result = Result.Failure(nil, error)
                            done()
                        })
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
