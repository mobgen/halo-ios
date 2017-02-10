//
//  SearchFilterSpec.swift
//  Halo
//
//  Created by Miguel López on 23/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
@testable import Halo

class SearchFilterSpec : BaseSpec {
    
    override func spec() {
        var searchFilter: SearchFilter!
        
        describe("A SearchFilter") {
            
            describe("its constructor method") {
                context("when type is not nil") {
                    beforeEach {
                        searchFilter = MockSearchFilter.createSearchFilter()
                    }
                    
                    it("works") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.operation).to(equal(MockSearchFilter.TestOperation.description))
                        expect(searchFilter.property).to(equal(MockSearchFilter.TestProperty))
                        expect(searchFilter.value as? String).to(equal(MockSearchFilter.TestValueString))
                        expect(searchFilter.type).to(equal(MockSearchFilter.TestType))
                    }
                }
                
                context("when type is nil and value is a string") {
                    beforeEach {
                        searchFilter = MockSearchFilter.createSearchFilterWithoutType()
                    }
                    
                    it("type is string") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("string"))
                    }
                }
                
                context("when type is nil and value is a NSNumber") {
                    beforeEach {
                        searchFilter = MockSearchFilter.createSearchFilterWithValueNumberWithoutType()
                    }
                    
                    it("type is number") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("number"))
                    }
                }
                
                context("when type is nil and value is a NSArray of String") {
                    beforeEach {
                        searchFilter = MockSearchFilter.createSearchFilterWithValueArrayOfStringWithoutType()
                    }
                    
                    it("type is string") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("string"))
                    }
                }
                
                context("when type is nil and value is a NSArray of NSNumber") {
                    beforeEach {
                        searchFilter = MockSearchFilter.createSearchFilterWithValueArrayOfNumberWithoutType()
                    }
                    
                    it("type is number") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("number"))
                    }
                }
                
                context("when type is nil and value is a NSArray of other type") {
                    beforeEach {
                        searchFilter = MockSearchFilter.createSearchFilterWithValueArrayOfOtherWithoutType()
                    }
                    
                    it("type is null") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("null"))
                    }
                }
                
                context("when type is nil and value is an empty NSArray") {
                    beforeEach {
                        searchFilter = MockSearchFilter.createSearchFilterWithValueEmptyArrayWithoutType()
                    }
                    
                    it("type is string") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("string"))
                    }
                }
                
                context("when type is nil and value is type Any") {
                    beforeEach {
                        searchFilter = MockSearchFilter.createSearchFilterWithoutType(value: MockSearchFilter.TestValueAny)
                    }
                    
                    it("type is null") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("null"))
                    }
                }
            }
            
            describe("its type property") {
                beforeEach {
                    searchFilter = MockSearchFilter.createSearchFilterWithoutType(value: nil)
                }
                
                context("when value is set with a string") {
                    beforeEach {
                        searchFilter.value = MockSearchFilter.TestValueString
                    }
                    
                    it("returns string") {
                        expect(searchFilter.type).toNot(beNil())
                        expect(searchFilter.type).to(equal("string"))
                    }
                }
                
                context("when value is set with a NSNumber") {
                    beforeEach {
                        searchFilter.value = MockSearchFilter.TestValueNumber
                    }
                    
                    it("returns number") {
                        expect(searchFilter.type).toNot(beNil())
                        expect(searchFilter.type).to(equal("number"))
                    }
                }
                
                context("when value is set with a NSArray of String") {
                    beforeEach {
                        searchFilter.value = MockSearchFilter.TestValueArrayOfString
                    }
                    
                    it("returns string") {
                        expect(searchFilter.type).toNot(beNil())
                        expect(searchFilter.type).to(equal("string"))
                    }
                }
                
                context("when value is set with a NSArray of Number") {
                    beforeEach {
                        searchFilter.value = MockSearchFilter.TestValueArrayOfNumber
                    }
                    
                    it("returns number") {
                        expect(searchFilter.type).toNot(beNil())
                        expect(searchFilter.type).to(equal("number"))
                    }
                }
                
                context("when value is set with a NSArray of other types") {
                    beforeEach {
                        searchFilter.value = MockSearchFilter.TestValueArrayOfOther
                    }
                    
                    it("returns null") {
                        expect(searchFilter.type).toNot(beNil())
                        expect(searchFilter.type).to(equal("null"))
                    }
                }
                
                context("when value is set with an empty NSArray") {
                    beforeEach {
                        searchFilter.value = MockSearchFilter.TestValueEmptyArray
                    }
                    
                    it("returns string") {
                        expect(searchFilter.type).toNot(beNil())
                        expect(searchFilter.type).to(equal("string"))
                    }
                }
                
                context("when value is set with type Any") {
                    beforeEach {
                        searchFilter.value = MockSearchFilter.TestValueAny
                    }
                    
                    it("returns null") {
                        expect(searchFilter.type).toNot(beNil())
                        expect(searchFilter.type).to(equal("null"))
                    }
                }
            }
            
            describe("its body property") {
                var dictReturnedByBody: [String: Any]!
                
                beforeEach {
                    searchFilter = MockSearchFilter.createSearchFilter()
                }
                
                context("when value is not nil") {
                    beforeEach {
                        searchFilter.condition = MockSearchFilter.TestCondition
                        searchFilter.operands = [SearchFilter()]
                        dictReturnedByBody = searchFilter.body
                    }
                    
                    it("works") {
                        expect(dictReturnedByBody["condition"] as? String).to(equal(MockSearchFilter.TestCondition))
                        expect((dictReturnedByBody["operands"] as? [[String: Any]])?.count).to(equal(1))
                        expect(dictReturnedByBody["operation"] as? String).to(equal(MockSearchFilter.TestOperation.description))
                        expect(dictReturnedByBody["property"] as? String).to(equal(MockSearchFilter.TestProperty))
                        expect(dictReturnedByBody["value"] as? String).to(equal(MockSearchFilter.TestValueString))
                        expect(dictReturnedByBody["type"] as? String).to(equal(MockSearchFilter.TestType))
                    }
                }
                
                context("when value is nil") {
                    beforeEach {
                        searchFilter.value = nil
                        searchFilter.condition = MockSearchFilter.TestCondition
                        searchFilter.operands = [SearchFilter()]
                        dictReturnedByBody = searchFilter.body
                    }
                    
                    it("works") {
                        expect(dictReturnedByBody["condition"] as? String).to(equal(MockSearchFilter.TestCondition))
                        expect((dictReturnedByBody["operands"] as? [[String: Any]])?.count).to(equal(1))
                        expect(dictReturnedByBody["operation"] as? String).to(equal(MockSearchFilter.TestOperation.description))
                        expect(dictReturnedByBody["property"] as? String).to(equal(MockSearchFilter.TestProperty))
                        expect(dictReturnedByBody["value"] as? NSNull).to(equal(NSNull()))
                        expect(dictReturnedByBody["type"] as? String).to(equal("null"))
                    }
                }
            }
        }
    }
}
