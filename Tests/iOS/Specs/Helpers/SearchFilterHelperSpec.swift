//
//  SearchFilterHelperSpec.swift
//  Halo
//
//  Created by Miguel López on 28/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class SearchFilterHelperSpec : BaseSpec {
    
    static let TestProperty = "testProperty"
    static let TestValue = "testValue"
    static let TestType = "testType"
    
    override func spec() {
        super.spec()
        
        var searchFilter: SearchFilter?
        var searchFilterBis: SearchFilter?
        
        describe("The \"eq\" method helper") {
            beforeEach {
                searchFilter = eq(property: SearchFilterHelperSpec.TestProperty, value: SearchFilterHelperSpec.TestValue, type: SearchFilterHelperSpec.TestType)
            }
            
            it("returns a correct SearchFilter") {
                expect(searchFilter).toNot(beNil())
                expect(searchFilter?.operation?.description).to(equal(SearchFilterOperation.eq.description))
                expect(searchFilter?.property).to(equal(SearchFilterHelperSpec.TestProperty))
                expect(searchFilter?.value as? String).to(equal(SearchFilterHelperSpec.TestValue))
                expect(searchFilter?.type).to(equal(SearchFilterHelperSpec.TestType))
            }
        }
        
        describe("The \"neq\" method helper") {
            beforeEach {
                searchFilter = neq(property: SearchFilterHelperSpec.TestProperty, value: SearchFilterHelperSpec.TestValue, type: SearchFilterHelperSpec.TestType)
            }
            
            it("returns a correct SearchFilter") {
                expect(searchFilter).toNot(beNil())
                expect(searchFilter?.operation?.description).to(equal(SearchFilterOperation.neq.description))
                expect(searchFilter?.property).to(equal(SearchFilterHelperSpec.TestProperty))
                expect(searchFilter?.value as? String).to(equal(SearchFilterHelperSpec.TestValue))
                expect(searchFilter?.type).to(equal(SearchFilterHelperSpec.TestType))
            }
        }
        
        describe("The \"gt\" method helper") {
            beforeEach {
                searchFilter = gt(property: SearchFilterHelperSpec.TestProperty, value: SearchFilterHelperSpec.TestValue, type: SearchFilterHelperSpec.TestType)
            }
            
            it("returns a correct SearchFilter") {
                expect(searchFilter).toNot(beNil())
                expect(searchFilter?.operation?.description).to(equal(SearchFilterOperation.gt.description))
                expect(searchFilter?.property).to(equal(SearchFilterHelperSpec.TestProperty))
                expect(searchFilter?.value as? String).to(equal(SearchFilterHelperSpec.TestValue))
                expect(searchFilter?.type).to(equal(SearchFilterHelperSpec.TestType))
            }
        }
        
        describe("The \"lt\" method helper") {
            beforeEach {
                searchFilter = lt(property: SearchFilterHelperSpec.TestProperty, value: SearchFilterHelperSpec.TestValue, type: SearchFilterHelperSpec.TestType)
            }
            
            it("returns a correct SearchFilter") {
                expect(searchFilter).toNot(beNil())
                expect(searchFilter?.operation?.description).to(equal(SearchFilterOperation.lt.description))
                expect(searchFilter?.property).to(equal(SearchFilterHelperSpec.TestProperty))
                expect(searchFilter?.value as? String).to(equal(SearchFilterHelperSpec.TestValue))
                expect(searchFilter?.type).to(equal(SearchFilterHelperSpec.TestType))
            }
        }
        
        describe("The \"gte\" method helper") {
            beforeEach {
                searchFilter = gte(property: SearchFilterHelperSpec.TestProperty, value: SearchFilterHelperSpec.TestValue, type: SearchFilterHelperSpec.TestType)
            }
            
            it("returns a correct SearchFilter") {
                expect(searchFilter).toNot(beNil())
                expect(searchFilter?.operation?.description).to(equal(SearchFilterOperation.gte.description))
                expect(searchFilter?.property).to(equal(SearchFilterHelperSpec.TestProperty))
                expect(searchFilter?.value as? String).to(equal(SearchFilterHelperSpec.TestValue))
                expect(searchFilter?.type).to(equal(SearchFilterHelperSpec.TestType))
            }
        }
        
        describe("The \"lte\" method helper") {
            beforeEach {
                searchFilter = lte(property: SearchFilterHelperSpec.TestProperty, value: SearchFilterHelperSpec.TestValue, type: SearchFilterHelperSpec.TestType)
            }
            
            it("returns a correct SearchFilter") {
                expect(searchFilter).toNot(beNil())
                expect(searchFilter?.operation?.description).to(equal(SearchFilterOperation.lte.description))
                expect(searchFilter?.property).to(equal(SearchFilterHelperSpec.TestProperty))
                expect(searchFilter?.value as? String).to(equal(SearchFilterHelperSpec.TestValue))
                expect(searchFilter?.type).to(equal(SearchFilterHelperSpec.TestType))
            }
        }
        
        describe("The \"valueIn\" method helper") {
            beforeEach {
                searchFilter = valueIn(property: SearchFilterHelperSpec.TestProperty, value: SearchFilterHelperSpec.TestValue, type: SearchFilterHelperSpec.TestType)
            }
            
            it("returns a correct SearchFilter") {
                expect(searchFilter).toNot(beNil())
                expect(searchFilter?.operation?.description).to(equal(SearchFilterOperation.in.description))
                expect(searchFilter?.property).to(equal(SearchFilterHelperSpec.TestProperty))
                expect(searchFilter?.value as? String).to(equal(SearchFilterHelperSpec.TestValue))
                expect(searchFilter?.type).to(equal(SearchFilterHelperSpec.TestType))
            }
        }
        
        describe("The \"valueNotIn\" method helper") {
            beforeEach {
                searchFilter = valueNotIn(property: SearchFilterHelperSpec.TestProperty, value: SearchFilterHelperSpec.TestValue, type: SearchFilterHelperSpec.TestType)
            }
            
            it("returns a correct SearchFilter") {
                expect(searchFilter).toNot(beNil())
                expect(searchFilter?.operation?.description).to(equal(SearchFilterOperation.notIn.description))
                expect(searchFilter?.property).to(equal(SearchFilterHelperSpec.TestProperty))
                expect(searchFilter?.value as? String).to(equal(SearchFilterHelperSpec.TestValue))
                expect(searchFilter?.type).to(equal(SearchFilterHelperSpec.TestType))
            }
        }
        
        describe("The \"or\" method helper") {
            var searchFilterOr: SearchFilter?
            
            beforeEach {
                searchFilter = valueNotIn(property: SearchFilterHelperSpec.TestProperty, value: SearchFilterHelperSpec.TestValue, type: SearchFilterHelperSpec.TestType)
                searchFilterBis = eq(property: SearchFilterHelperSpec.TestProperty, value: SearchFilterHelperSpec.TestValue, type: SearchFilterHelperSpec.TestType)
                
                searchFilterOr = or(searchFilter!, searchFilterBis!)
            }
            
            it("returns a correct SearchFilter") {
                expect(searchFilterOr).toNot(beNil())
                expect(searchFilterOr?.condition).to(equal("or"))
                expect(searchFilterOr?.operands?.count).to(equal(2))
            }
        }
        
        describe("The \"and\" method helper") {
            var searchFilterAnd: SearchFilter?
            
            beforeEach {
                searchFilter = valueNotIn(property: SearchFilterHelperSpec.TestProperty, value: SearchFilterHelperSpec.TestValue, type: SearchFilterHelperSpec.TestType)
                searchFilterBis = eq(property: SearchFilterHelperSpec.TestProperty, value: SearchFilterHelperSpec.TestValue, type: SearchFilterHelperSpec.TestType)
                
                searchFilterAnd = and(searchFilter!, searchFilterBis!)
            }
            
            it("returns a correct SearchFilter") {
                expect(searchFilterAnd).toNot(beNil())
                expect(searchFilterAnd?.condition).to(equal("and"))
                expect(searchFilterAnd?.operands?.count).to(equal(2))
            }
        }
        
        describe("A SearchFilterHelper") {
            describe("its getDraftItems method") {
                beforeEach {
                    searchFilter = SearchFilterHelper.getDraftItems()
                }
                
                it("returns a correct SearchFilter") {
                    expect(searchFilter).toNot(beNil())
                    expect(searchFilter?.condition).to(equal("and"))
                    expect(searchFilter?.operands?.count).to(equal(4))
                }
            }
            
            describe("its getLastUpdatedItems method") {
                beforeEach {
                    searchFilter = SearchFilterHelper.getLastUpdatedItems(from: Date())
                }
                
                it("returns a correct SearchFilter") {
                    expect(searchFilter).toNot(beNil())
                    expect(searchFilter?.condition).to(equal("and"))
                    expect(searchFilter?.operands?.count).to(equal(3))
                }
            }
            
            describe("its getArchivedItems method") {
                beforeEach {
                    searchFilter = SearchFilterHelper.getArchivedItems()
                }
                
                it("returns a correct SearchFilter") {
                    expect(searchFilter).toNot(beNil())
                    expect(searchFilter?.condition).to(equal("and"))
                    expect(searchFilter?.operands?.count).to(equal(3))
                }
            }
            
            describe("its getExpiredItems method") {
                beforeEach {
                    searchFilter = SearchFilterHelper.getExpiredItems()
                }
                
                it("returns a correct SearchFilter") {
                    expect(searchFilter).toNot(beNil())
                    expect(searchFilter?.condition).to(equal("and"))
                    expect(searchFilter?.operands?.count).to(equal(2))
                }
            }
            
            describe("its getPublishedItems method") {
                beforeEach {
                    searchFilter = SearchFilterHelper.getPublishedItems()
                }
                
                it("returns a correct SearchFilter") {
                    expect(searchFilter).toNot(beNil())
                    expect(searchFilter?.condition).to(equal("and"))
                    expect(searchFilter?.operands?.count).to(equal(3))
                }
            }
        }
    }
    
}
