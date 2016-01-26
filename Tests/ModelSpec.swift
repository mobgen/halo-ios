//
//  ModelSpec.swift
//  HaloSDK
//
//  Created by Borja on 03/09/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Halo

class ModelSpec: QuickSpec {

    override func spec() {

        describe("The device extension") {
            it("provides the right model name") {
                expect(UIDevice.currentDevice().getModelName("iPad3,5") == "iPad 4").to(beTrue())
                expect(UIDevice.currentDevice().getModelName("Blah") == "Blah").to(beTrue())
            }
        }
        
    }

}