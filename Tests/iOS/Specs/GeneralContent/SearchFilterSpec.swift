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
    
    static let TestOperation: SearchFilterOperation = .eq
    static let TestProperty = "testProperty"
    static let TestValueString = "testValueString"
    static let TestValueNumber = NSNumber(value: true)
    static let TestValueEmptyArray: [Any] = []
    static let TestValueArrayOfString = [SearchFilterSpec.TestValueString]
    static let TestValueArrayOfNumber = [SearchFilterSpec.TestValueNumber]
    static let TestValueArrayOfOther = [["test": "test"]]
    static let TestValueAny: Any? = nil
    static let TestType = "string"
    static let TestCondition = "testCondition"
    
    override func spec() {
        super.spec()
        
        var searchFilter: SearchFilter!
        
        describe("A SearchFilter") {
            
            describe("its constructor method") {
                context("when type is not nil") {
                    beforeEach {
                        searchFilter = SearchFilter(operation: SearchFilterSpec.TestOperation, property: SearchFilterSpec.TestProperty, value: SearchFilterSpec.TestValueString, type: SearchFilterSpec.TestType)
                    }
                    
                    it("works") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.operation).to(equal(SearchFilterSpec.TestOperation.description))
                        expect(searchFilter.property).to(equal(SearchFilterSpec.TestProperty))
                        expect(searchFilter.value as? String).to(equal(SearchFilterSpec.TestValueString))
                        expect(searchFilter.type).to(equal(SearchFilterSpec.TestType))
                    }
                }
                
                context("when type is nil and value is a string") {
                    beforeEach {
                        searchFilter = SearchFilter(operation: SearchFilterSpec.TestOperation, property: SearchFilterSpec.TestProperty, value: SearchFilterSpec.TestValueString)
                    }
                    
                    it("type is string") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("string"))
                    }
                }
                
                context("when type is nil and value is a NSNumber") {
                    beforeEach {
                        searchFilter = SearchFilter(operation: SearchFilterSpec.TestOperation, property: SearchFilterSpec.TestProperty, value: SearchFilterSpec.TestValueNumber)
                    }
                    
                    it("type is number") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("number"))
                    }
                }
                
                context("when type is nil and value is a NSArray of String") {
                    beforeEach {
                        searchFilter = SearchFilter(operation: SearchFilterSpec.TestOperation, property: SearchFilterSpec.TestProperty, value: SearchFilterSpec.TestValueArrayOfString)
                    }
                    
                    it("type is string") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("string"))
                    }
                }
                
                context("when type is nil and value is a NSArray of NSNumber") {
                    beforeEach {
                        searchFilter = SearchFilter(operation: SearchFilterSpec.TestOperation, property: SearchFilterSpec.TestProperty, value: SearchFilterSpec.TestValueArrayOfNumber)
                    }
                    
                    it("type is number") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("number"))
                    }
                }
                
                context("when type is nil and value is a NSArray of other type") {
                    beforeEach {
                        searchFilter = SearchFilter(operation: SearchFilterSpec.TestOperation, property: SearchFilterSpec.TestProperty, value: SearchFilterSpec.TestValueArrayOfOther)
                    }
                    
                    it("type is null") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("null"))
                    }
                }
                
                context("when type is nil and value is an empty NSArray") {
                    beforeEach {
                        searchFilter = SearchFilter(operation: SearchFilterSpec.TestOperation, property: SearchFilterSpec.TestProperty, value: SearchFilterSpec.TestValueEmptyArray)
                    }
                    
                    it("type is string") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("string"))
                    }
                }
                
                context("when type is nil and value is type Any") {
                    beforeEach {
                        searchFilter = SearchFilter(operation: SearchFilterSpec.TestOperation, property: SearchFilterSpec.TestProperty, value: SearchFilterSpec.TestValueAny)
                    }
                    
                    it("type is null") {
                        expect(searchFilter).toNot(beNil())
                        expect(searchFilter.type).to(equal("null"))
                    }
                }
            }
            
            describe("its type property") {
                beforeEach {
                    searchFilter = SearchFilter(operation: SearchFilterSpec.TestOperation, property: SearchFilterSpec.TestProperty, value: nil)
                }
                
                context("when value is set with a string") {
                    beforeEach {
                        searchFilter.value = SearchFilterSpec.TestValueString
                    }
                    
                    it("returns string") {
                        expect(searchFilter.type).toNot(beNil())
                        expect(searchFilter.type).to(equal("string"))
                    }
                }
                
                context("when value is set with a NSNumber") {
                    beforeEach {
                        searchFilter.value = SearchFilterSpec.TestValueNumber
                    }
                    
                    it("returns number") {
                        expect(searchFilter.type).toNot(beNil())
                        expect(searchFilter.type).to(equal("number"))
                    }
                }
                
                context("when value is set with a NSArray of String") {
                    beforeEach {
                        searchFilter.value = SearchFilterSpec.TestValueArrayOfString
                    }
                    
                    it("returns string") {
                        expect(searchFilter.type).toNot(beNil())
                        expect(searchFilter.type).to(equal("string"))
                    }
                }
                
                context("when value is set with a NSArray of Number") {
                    beforeEach {
                        searchFilter.value = SearchFilterSpec.TestValueArrayOfNumber
                    }
                    
                    it("returns number") {
                        expect(searchFilter.type).toNot(beNil())
                        expect(searchFilter.type).to(equal("number"))
                    }
                }
                
                context("when value is set with a NSArray of other types") {
                    beforeEach {
                        searchFilter.value = SearchFilterSpec.TestValueArrayOfOther
                    }
                    
                    it("returns null") {
                        expect(searchFilter.type).toNot(beNil())
                        expect(searchFilter.type).to(equal("null"))
                    }
                }
                
                context("when value is set with an empty NSArray") {
                    beforeEach {
                        searchFilter.value = SearchFilterSpec.TestValueEmptyArray
                    }
                    
                    it("returns string") {
                        expect(searchFilter.type).toNot(beNil())
                        expect(searchFilter.type).to(equal("string"))
                    }
                }
                
                context("when value is set with type Any") {
                    beforeEach {
                        searchFilter.value = SearchFilterSpec.TestValueAny
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
                    searchFilter = SearchFilter(operation: SearchFilterSpec.TestOperation, property: SearchFilterSpec.TestProperty, value: SearchFilterSpec.TestValueString, type: SearchFilterSpec.TestType)
                }
                
                context("when value is not nil") {
                    beforeEach {
                        searchFilter.condition = SearchFilterSpec.TestCondition
                        searchFilter.operands = [SearchFilter()]
                        dictReturnedByBody = searchFilter.body
                    }
                    
                    it("works") {
                        expect(dictReturnedByBody["condition"] as? String).to(equal(SearchFilterSpec.TestCondition))
                        expect((dictReturnedByBody["operands"] as? [[String: Any]])?.count).to(equal(1))
                        expect(dictReturnedByBody["operation"] as? String).to(equal(SearchFilterSpec.TestOperation.description))
                        expect(dictReturnedByBody["property"] as? String).to(equal(SearchFilterSpec.TestProperty))
                        expect(dictReturnedByBody["value"] as? String).to(equal(SearchFilterSpec.TestValueString))
                        expect(dictReturnedByBody["type"] as? String).to(equal(SearchFilterSpec.TestType))
                    }
                }
                
                context("when value is nil") {
                    beforeEach {
                        searchFilter.value = nil
                        searchFilter.condition = SearchFilterSpec.TestCondition
                        searchFilter.operands = [SearchFilter()]
                        dictReturnedByBody = searchFilter.body
                    }
                    
                    it("works") {
                        expect(dictReturnedByBody["condition"] as? String).to(equal(SearchFilterSpec.TestCondition))
                        expect((dictReturnedByBody["operands"] as? [[String: Any]])?.count).to(equal(1))
                        expect(dictReturnedByBody["operation"] as? String).to(equal(SearchFilterSpec.TestOperation.description))
                        expect(dictReturnedByBody["property"] as? String).to(equal(SearchFilterSpec.TestProperty))
                        expect(dictReturnedByBody["value"] as? NSNull).to(equal(NSNull()))
                        expect(dictReturnedByBody["type"] as? String).to(equal("null"))
                    }
                }
            }
        }
    }
}
