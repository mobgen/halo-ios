//
//  PaginationInfoSpec.swift
//  Halo
//
//  Created by Miguel López on 27/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class PaginationInfoSpec : BaseSpec {
    
    override func spec() {
        super.spec()
        
        describe("A PaginationInfo") {
            var paginationInfo: PaginationInfo!
            
            describe("its fromDictionary method") {
                context("with a dictionary with empty values") {
                    beforeEach {
                        paginationInfo = PaginationInfo.fromDictionary(dict: [:])
                    }
                    
                    it("works") {
                        expect(paginationInfo).toNot(beNil())
                        expect(paginationInfo.page).to(equal(0))
                        expect(paginationInfo.limit).to(equal(0))
                        expect(paginationInfo.offset).to(equal(0))
                        expect(paginationInfo.totalItems).to(equal(0))
                        expect(paginationInfo.totalPages).to(equal(0))
                    }
                }
                
                context("with a dictionary with values") {
                    beforeEach {
                        guard
                            let filePath = OHPathForFile("pagination_info.json", type(of: self)),
                            let jsonData = NSData(contentsOfFile: filePath) as? Data,
                            let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]),
                            let dict = jsonResult as? [String: AnyObject]
                            else {
                                XCTFail("The creation of fake PaginationInfo fails.")
                                return
                        }
                        paginationInfo = PaginationInfo.fromDictionary(dict: dict)
                    }
                    
                    it("works") {
                        expect(paginationInfo).toNot(beNil())
                        expect(paginationInfo.page).to(equal(MockPaginationInfo.TestPage))
                        expect(paginationInfo.limit).to(equal(MockPaginationInfo.TestLimit))
                        expect(paginationInfo.offset).to(equal(MockPaginationInfo.TestOffset))
                        expect(paginationInfo.totalItems).to(equal(MockPaginationInfo.TestTotalItems))
                        expect(paginationInfo.totalPages).to(equal(MockPaginationInfo.TestTotalPages))
                    }
                }
            }
            
            describe("its constructor method") {
                context("with a NSCoder") {
                    var paginationInfoRestored: PaginationInfo?
                    
                    beforeEach {
                        // Save to temp file.
                        let path = NSTemporaryDirectory()
                        let locToSave = path.appending("testPaginationInfo")
                        paginationInfo = MockPaginationInfo.createPaginationInfo()
                        NSKeyedArchiver.archiveRootObject(paginationInfo, toFile: locToSave)
                        paginationInfoRestored = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? PaginationInfo
                    }
                    
                    it("works") {
                        expect(paginationInfoRestored).toNot(beNil())
                        expect(paginationInfoRestored!.page).to(equal(MockPaginationInfo.TestPage))
                        expect(paginationInfoRestored!.limit).to(equal(MockPaginationInfo.TestLimit))
                        expect(paginationInfoRestored!.offset).to(equal(MockPaginationInfo.TestOffset))
                        expect(paginationInfoRestored!.totalItems).to(equal(MockPaginationInfo.TestTotalItems))
                        expect(paginationInfoRestored!.totalPages).to(equal(MockPaginationInfo.TestTotalPages))
                    }
                }
            }
        }
    }
    
}
