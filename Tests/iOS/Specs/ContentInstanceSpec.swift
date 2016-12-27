//
//  ContentInstanceSpec.swift
//  Halo
//
//  Created by Miguel López on 27/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class ContentInstanceSpec : BaseSpec {
    
    override func spec() {
        super.spec()
        
        describe("A ContentInstance") {
            var contentInstance: ContentInstance!
            
            beforeEach {
                contentInstance = MockContentInstance.createFromJson()
            }
            
            describe("its getValue method") {
                it("returns the expected value") {
                    let realValue = contentInstance.getValue(key: MockContentInstance.TestValueName) as? Bool
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
