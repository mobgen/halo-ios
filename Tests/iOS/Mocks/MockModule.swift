//
//  MockModule.swift
//  Halo
//
//  Created by Miguel López on 27/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class MockModule : Module {
    
    static let TestName = "testModule"
    static let TestId = "000000000000000000000004"
    static let TestIsSingle = false
    static let TestCustomerId = 2
    static let TestTags: [Tag] = []
    static let TestCreatedBy = "testAdmin"
    static let TestUpdatedBy = "undefined"
    static let TestDeletedBy = "testAdmin2"
    static let TestCreatedAt = Date(timeIntervalSince1970: 1474036570134/1000)
    static let TestUpdatedAt = Date(timeIntervalSince1970: 1474063790249/1000)
    static let TestDeletedAt = Date(timeIntervalSince1970: 1474063320249/1000)
    
    class func createFromJson(_ filePath: String? = OHPathForFileInBundle("module_without_tags_with_isSingle.json", Bundle.init(for: MockModule.classForCoder()))) -> Module? {
        guard
            let filePath = filePath,
            let jsonData = NSData(contentsOfFile: filePath) as Data?,
            let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]),
            let dict = jsonResult as? [String: AnyObject]
            else {
                XCTFail("The creation of fake Module fails.")
                return nil
        }
        return Module.fromDictionary(dict: dict)
    }
}
