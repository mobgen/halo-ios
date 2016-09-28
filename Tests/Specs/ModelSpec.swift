//
//  ModelSpec.swift
//  HaloSDK
//
//  Created by Borja on 03/09/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
@testable import Halo

class ModelSpec: BaseSpec {

    override func spec() {

        super.spec()
        
        describe("The device extension") {
            it("provides the right model name") {
                expect(UIDevice.currentDevice().modelName).to(equal("Simulator"))
                expect(UIDevice.currentDevice().modelName).toNot(equal("iPhone 6"))
            }
        }
        
        describe("The search filter") {
            
            it("is built correctly") {
                
                let _ = SearchFilter(operation: .Eq, property: "test", value: "blah")
                
            }
            
        }
        
    }

}
