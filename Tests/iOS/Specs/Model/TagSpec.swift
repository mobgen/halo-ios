//
//  TagSpec.swift
//  Halo
//
//  Created by Miguel López on 29/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
@testable import Halo

class TagSpec : BaseSpec {
    
    override func spec() {
        super.spec()
        
        var tag: Tag?
        
        describe("A Tag") {
            describe("its constructor method") {
                context("with a type") {
                    beforeEach {
                        tag = MockTag.createTag()
                    }
                    
                    it("works") {
                        expect(tag).toNot(beNil())
                        expect(tag?.name).to(equal(MockTag.TestName))
                        expect(tag?.value).to(equal(MockTag.TestValue))
                        expect(tag?.type).to(equal(MockTag.TestType))
                    }
                }
                
                context("without a type") {
                    beforeEach {
                        tag = MockTag.createTag(type: nil)
                    }
                    
                    it("works") {
                        expect(tag).toNot(beNil())
                        expect(tag?.name).to(equal(MockTag.TestName))
                        expect(tag?.value).to(equal(MockTag.TestValue))
                        expect(tag?.type).to(equal("000000000000000000000002"))
                    }
                }
                
                context("with a NSCoder") {
                    var tagRestored: Tag?
                    
                    beforeEach {
                        // Save to temp file.
                        let path = NSTemporaryDirectory()
                        let locToSave = path.appending("testTag")
                        tag = MockTag.createTag()
                        tag!.id = MockTag.TestId
                        NSKeyedArchiver.archiveRootObject(tag!, toFile: locToSave)
                        tagRestored = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? Tag
                    }
                    
                    it("works") {
                        expect(tag).toNot(beNil())
                        expect(tagRestored?.id).to(equal(MockTag.TestId))
                        expect(tagRestored?.name).to(equal(MockTag.TestName))
                        expect(tagRestored?.value).to(equal(MockTag.TestValue))
                        expect(tagRestored?.type).to(equal(MockTag.TestType))
                    }
                }
            }
            
            describe("its toDictionary method") {
                var dict: [String: Any]?
                
                beforeEach {
                    tag = MockTag.createTag()
                    tag!.id = MockTag.TestId
                    dict = tag!.toDictionary()
                }
                
                it("works") {
                    expect(dict).toNot(beNil())
                    expect(dict!["id"] as? String).to(equal(MockTag.TestId))
                    expect(dict!["name"] as? String).to(equal(MockTag.TestName))
                    expect(dict!["value"] as? String).to(equal(MockTag.TestValue))
                    expect(dict!["tagType"] as? String).to(equal(MockTag.TestType))
                }
            }
            
            describe("its fromDictionary method") {
                beforeEach {
                    tag = Tag.fromDictionary(dict: MockTag.TestDict)
                }
                
                it("works") {
                    expect(tag).toNot(beNil())
                    expect(tag?.id).to(equal(MockTag.TestId))
                    expect(tag?.name).to(equal(MockTag.TestName))
                    expect(tag?.value).to(equal(MockTag.TestValue))
                    expect(tag?.type).to(equal(MockTag.TestType))
                }
            }
            
            describe("its isEqual method") {
                var resultIsEqual: Bool!
                
                beforeEach {
                    tag = MockTag.createTag()
                }
                
                context("when it's not a Tag object") {
                    beforeEach {
                        resultIsEqual = tag!.isEqual(self)
                    }
                    
                    it("works") {
                        expect(resultIsEqual).to(beFalse())
                    }
                }
                
                xcontext("when it's a Tag object and it has the same name") {
                    beforeEach {
                        let tagToCompare = MockTag.createTag()
                        resultIsEqual = tag!.isEqual(tagToCompare)
                    }
                    
                    it("works") {
                        expect(resultIsEqual).to(beTrue())
                    }
                }
                
                context("when it's a Tag object and it has a different name") {
                    beforeEach {
                        let tagToCompare = MockTag.createTag()
                        tagToCompare.name = "another name"
                        resultIsEqual = tag!.isEqual(tagToCompare)
                    }
                    
                    it("works") {
                        expect(resultIsEqual).to(beFalse())
                    }
                }
            }
        }
    }
    
}
