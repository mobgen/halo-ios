//
//  MockPaginationInfo.swift
//  Halo
//
//  Created by Miguel López on 27/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import OHHTTPStubs
@testable import Halo

class MockPaginationInfo : PaginationInfo {
    
    static let TestPage = 2
    static let TestLimit = 20
    static let TestOffset = 20
    static let TestTotalItems = 100
    static let TestTotalPages = 5
    
    class func createPaginationInfo() -> PaginationInfo {
        return PaginationInfo(page: TestPage, limit: TestLimit, offset: TestOffset, totalItems: TestTotalItems, totalPages: TestTotalPages)
    }
    
    class func createFromJson(_ filePath: String? = OHPathForFileInBundle("pagination_info.json", Bundle.init(for: MockPaginationInfo.classForCoder()))) -> PaginationInfo? {
        guard
            let filePath = filePath,
            let jsonData = NSData(contentsOfFile: filePath) as? Data,
            let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]),
            let dict = jsonResult as? [String: AnyObject]
        else {
            XCTFail("The creation of fake PaginationInfo fails.")
            return nil
        }
        return PaginationInfo.fromDictionary(dict: dict)
    }
}
