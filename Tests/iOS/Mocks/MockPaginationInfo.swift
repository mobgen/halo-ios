//
//  MockPaginationInfo.swift
//  Halo
//
//  Created by Miguel López on 27/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

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
}
