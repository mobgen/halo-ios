//
//  MockSearchFilter.swift
//  Halo
//
//  Created by Miguel López on 23/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

@testable import Halo

class MockSearchFilter : SearchFilter {
    
    static let TestOperation: SearchFilterOperation = .eq
    static let TestProperty = "testProperty"
    
    static let TestValueString = "testValueString"
    static let TestValueNumber = NSNumber(value: true)
    static let TestValueEmptyArray: [Any] = []
    static let TestValueArrayOfString = [MockSearchFilter.TestValueString]
    static let TestValueArrayOfNumber = [MockSearchFilter.TestValueNumber]
    static let TestValueArrayOfOther = [["test": "test"]]
    static let TestValueAny: Any? = nil
    
    static let TestType = "string"
    static let TestCondition = "testCondition"
    
    class func createSearchFilter(value: Any? = MockSearchFilter.TestValueString) -> SearchFilter {
        return SearchFilter(operation: MockSearchFilter.TestOperation, property: MockSearchFilter.TestProperty, value: value, type: MockSearchFilter.TestType)
    }
    
    class func createSearchFilterWithoutType(value: Any? = MockSearchFilter.TestValueString) -> SearchFilter {
        return SearchFilter(operation: MockSearchFilter.TestOperation, property: MockSearchFilter.TestProperty, value: value)
    }
    
    class func createSearchFilterWithValueNumberWithoutType() -> SearchFilter {
        return SearchFilter(operation: MockSearchFilter.TestOperation, property: MockSearchFilter.TestProperty, value: MockSearchFilter.TestValueNumber)
    }
    
    class func createSearchFilterWithValueArrayOfStringWithoutType() -> SearchFilter {
        return SearchFilter(operation: MockSearchFilter.TestOperation, property: MockSearchFilter.TestProperty, value: MockSearchFilter.TestValueArrayOfString)
    }
    
    class func createSearchFilterWithValueArrayOfNumberWithoutType() -> SearchFilter {
        return SearchFilter(operation: MockSearchFilter.TestOperation, property: MockSearchFilter.TestProperty, value: MockSearchFilter.TestValueArrayOfNumber)
    }
    
    class func createSearchFilterWithValueArrayOfOtherWithoutType() -> SearchFilter {
        return SearchFilter(operation: MockSearchFilter.TestOperation, property: MockSearchFilter.TestProperty, value: MockSearchFilter.TestValueArrayOfOther)
    }
    
    class func createSearchFilterWithValueEmptyArrayWithoutType() -> SearchFilter {
        return SearchFilter(operation: MockSearchFilter.TestOperation, property: MockSearchFilter.TestProperty, value: MockSearchFilter.TestValueEmptyArray)
    }
}
