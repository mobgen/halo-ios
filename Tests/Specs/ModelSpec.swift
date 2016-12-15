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
                expect(UIDevice.current.modelName).to(equal("Simulator"))
                expect(UIDevice.current.modelName).toNot(equal("iPhone 6"))
            }
        }
        
        describe("The search filter") {
            
            it("is built correctly") {
                
                let _ = SearchFilter(operation: .eq, property: "test", value: "blah")
                
            }
            
        }
        
    }

}
