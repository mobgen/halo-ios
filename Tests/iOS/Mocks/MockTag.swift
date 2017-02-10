//
//  MockTag.swift
//  Halo
//
//  Created by Miguel López on 29/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
@testable import Halo

class MockTag {
    
    static let TestName = "testNameTag"
    static let TestValue = "testValueTag"
    static let TestType = "testTypeTag"
    static let TestId = "testIdTag"
    
    static let TestDict: [String: Any] = [
        "id": MockTag.TestId,
        "name": MockTag.TestName,
        "value": MockTag.TestValue,
        "tagType": MockTag.TestType
    ]
    
    class func createTag(type: String? = TestType) -> Tag {
        return Tag(name: MockTag.TestName, value: MockTag.TestValue, type: type)
    }
}
