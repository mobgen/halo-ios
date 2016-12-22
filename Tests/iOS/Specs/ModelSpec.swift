//
//  ModelSpec.swift
//  HaloSDK
//
//  Created by Borja on 03/09/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class ModelSpec: BaseSpec {

    override func spec() {

        super.spec()
        
        describe("The device extension") {
            it("provides the right model name") {
                expect(UIDevice.current.modelName).to(equal("Simulator"))
                expect(UIDevice.current.modelName).toNot(equal("iPhone 6"))
            }
        }
        
        test_ContentInstance()
    }
    
    func test_ContentInstance() {
        describe("a content instance") {
            var contentInstance: ContentInstance!
            
            beforeEach {
                guard
                    let filePath = OHPathForFile("content_instance.json", type(of: self)),
                    let jsonData = NSData(contentsOfFile: filePath) as? Data,
                    let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]),
                    let dict = jsonResult as? [String: AnyObject]
                else {
                    XCTFail("The creation of fake contentInstance fails.")
                    return
                }
                contentInstance = ContentInstance.fromDictionary(dict: dict)
            }
            
            describe("its getValue method") {
                it("returns the expected value") {
                    let realValue = contentInstance.getValue(key: "CXJP2HJ Boolean") as? Bool
                    expect(realValue).to(equal(true))
                }
            }
            
            describe("its isRemoved method") {
                context("when removedAt is nil") {
                    it("returns false") {
                        expect(contentInstance.isRemoved()).to(beFalse())
                    }
                }
                
                context("when today is before the date of removedAt") {
                    beforeEach {
                        contentInstance.removedAt = Date().addingTimeInterval(36000)
                    }
                    
                    it("returns false") {
                        expect(contentInstance.isRemoved()).to(beFalse())
                    }
                }
                
                context("when today is after the date of removedAt") {
                    beforeEach {
                        contentInstance.removedAt = Date().addingTimeInterval(-36000)
                    }
                    
                    it("returns true") {
                        expect(contentInstance.isRemoved()).to(beTrue())
                    }
                }
            }
            
            describe("its isPublished method") {
                context("when publishedAt is nil") {
                    it("returns false") {
                        expect(contentInstance.isPublished()).to(beFalse())
                    }
                }
                
                context("when today is before the date of publishedAt") {
                    beforeEach {
                        contentInstance.publishedAt = Date().addingTimeInterval(36000)
                    }
                    
                    it("returns false") {
                        expect(contentInstance.isPublished()).to(beFalse())
                    }
                }
                
                context("when today is after the date of publishedAt") {
                    beforeEach {
                        contentInstance.publishedAt = Date().addingTimeInterval(-36000)
                    }
                    
                    it("returns true") {
                        expect(contentInstance.isPublished()).to(beTrue())
                    }
                }
            }
            
            describe("its isDeleted method") {
                context("when deletedAt is nil") {
                    it("returns false") {
                        expect(contentInstance.isDeleted()).to(beFalse())
                    }
                }
                
                context("when today is before the date of deletedAt") {
                    beforeEach {
                        contentInstance.deletedAt = Date().addingTimeInterval(36000)
                    }
                    
                    it("returns false") {
                        expect(contentInstance.isDeleted()).to(beFalse())
                    }
                }
                
                context("when today is after the date of deletedAt") {
                    beforeEach {
                        contentInstance.deletedAt = Date().addingTimeInterval(-36000)
                    }
                    
                    it("returns true") {
                        expect(contentInstance.isDeleted()).to(beTrue())
                    }
                }
            }
        }
    }

}
