//
//  ManagerSpec.swift
//  Halo
//
//  Created by Miguel López on 30/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
@testable import Halo

class ManagerSpec : BaseSpec {
    
    static let TestCustomValue = "testValue"
    
    override func spec() {
        
        describe("A HaloEnvironment enum") {
            var env: HaloEnvironment?
            
            describe("its constuctor method") {
                context("when passed \"int\"") {
                    beforeEach {
                        env = HaloEnvironment(rawValue: "int")
                    }
                    
                    it("returns .int") {
                        expect(env).toNot(beNil())
                        expect(env?.description).to(equal(HaloEnvironment.int.description))
                    }
                }
                
                context("when passed \"qa\"") {
                    beforeEach {
                        env = HaloEnvironment(rawValue: "qa")
                    }
                    
                    it("returns .qa") {
                        expect(env).toNot(beNil())
                        expect(env?.description).to(equal(HaloEnvironment.qa.description))
                    }
                }
                
                context("when passed \"stage\"") {
                    beforeEach {
                        env = HaloEnvironment(rawValue: "stage")
                    }
                    
                    it("returns .stage") {
                        expect(env).toNot(beNil())
                        expect(env?.description).to(equal(HaloEnvironment.stage.description))
                    }
                }
                
                context("when passed \"prod\"") {
                    beforeEach {
                        env = HaloEnvironment(rawValue: "prod")
                    }
                    
                    it("returns .prod") {
                        expect(env).toNot(beNil())
                        expect(env?.description).to(equal(HaloEnvironment.prod.description))
                    }
                }
                
                context("when passed a custom value") {
                    beforeEach {
                        env = HaloEnvironment(rawValue: ManagerSpec.TestCustomValue)
                    }
                    
                    it("returns .prod") {
                        expect(env).toNot(beNil())
                        expect(env?.description).to(equal(HaloEnvironment.custom(ManagerSpec.TestCustomValue).description))
                    }
                }
            }
            
            describe("its baseUrlString property") {
                context("when passed \"int\"") {
                    beforeEach {
                        env = HaloEnvironment(rawValue: "int")
                    }
                    
                    it("returns .int url") {
                        expect(env).toNot(beNil())
                        expect(env?.baseUrlString).to(equal("https://halo-int.mobgen.com"))
                    }
                }
                
                context("when passed \"qa\"") {
                    beforeEach {
                        env = HaloEnvironment(rawValue: "qa")
                    }
                    
                    it("returns .qa url") {
                        expect(env).toNot(beNil())
                        expect(env?.baseUrlString).to(equal("https://halo-qa.mobgen.com"))
                    }
                }
                
                context("when passed \"stage\"") {
                    beforeEach {
                        env = HaloEnvironment(rawValue: "stage")
                    }
                    
                    it("returns .stage url") {
                        expect(env).toNot(beNil())
                        expect(env?.baseUrlString).to(equal("https://halo-stage.mobgen.com"))
                    }
                }
                
                context("when passed \"prod\"") {
                    beforeEach {
                        env = HaloEnvironment(rawValue: "prod")
                    }
                    
                    it("returns .prod url") {
                        expect(env).toNot(beNil())
                        expect(env?.baseUrlString).to(equal("https://halo.mobgen.com"))
                    }
                }
                
                context("when passed a custom value") {
                    beforeEach {
                        env = HaloEnvironment(rawValue: ManagerSpec.TestCustomValue)
                    }
                    
                    it("returns the custom value url") {
                        expect(env).toNot(beNil())
                        expect(env?.baseUrlString).to(equal(ManagerSpec.TestCustomValue))
                    }
                }
            }
        }
    }
    
}
