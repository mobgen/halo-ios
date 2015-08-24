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

        beforeSuite {
            OHHTTPStubs.stubRequestsPassingTest({ request in
                return ObjCBool(request.URL!.host! == "halo-int.mobgen.com")
            }, withStubResponse: { request in OHHTTPStubsResponse(JSONObject: ["hello": "hello"], statusCode: 200, headers: ["Content-Type": "application/json"]) })
        }

        afterSuite {
            OHHTTPStubs.removeAllStubs()
        }

        describe("The core manager") {

            it("has been initialised properly") {
                let mgr = Halo.Manager.sharedInstance
                expect(mgr).toNot(beNil())
            }
        }
    }

}
