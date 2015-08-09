//
//  HaloCoreTests.swift
//  HaloCoreTests
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import Halo

class CoreSpec: QuickSpec {

    override func spec() {

        describe("The core manager") {
            it("has been initialised properly") {
                let mgr = Halo.Manager.sharedInstance
                expect(mgr).toNot(beNil())
            }
        }

    }

}
