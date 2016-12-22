//
//  DeviceSpec.swift
//  Halo
//
//  Created by Miguel López on 22/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class DeviceSpec: BaseSpec {
    
    static let TestNameTag = "testNameTag"
    static let TestValueTag = "testValueTag"
    static let TestValueUpdatedTag = "testValueUpdatedTag"
    
    override func spec() {
        
        super.spec()
        
        describe("A device") {
            var device: Device!
            
            beforeEach {
                device = Device()
            }
            
            describe("its addTag method") {
                context("when tag is new") {
                    beforeEach {
                        device.addTag(name: DeviceSpec.TestNameTag, value: DeviceSpec.TestValueTag)
                    }
                    
                    it("add the tag to tags array and has correct type.") {
                        expect(device.tags?[DeviceSpec.TestNameTag]).toNot(beNil())
                        expect(device.tags?[DeviceSpec.TestNameTag]!.value).to(equal(DeviceSpec.TestValueTag))
                        expect(device.tags?[DeviceSpec.TestNameTag]!.type).to(equal("000000000000000000000002"))
                    }
                }
                
                context("when tag already exists") {
                    beforeEach {
                        device.addTag(name: DeviceSpec.TestNameTag, value: DeviceSpec.TestValueTag)
                        device.addTag(name: DeviceSpec.TestNameTag, value: DeviceSpec.TestValueUpdatedTag)
                    }
                    
                    it("update the tag to tags array and has correct type.") {
                        expect(device.tags?[DeviceSpec.TestNameTag]).toNot(beNil())
                        expect(device.tags?[DeviceSpec.TestNameTag]!.value).to(equal(DeviceSpec.TestValueUpdatedTag))
                        expect(device.tags?[DeviceSpec.TestNameTag]!.type).to(equal("000000000000000000000002"))
                    }
                }
            }
            
            describe("its addSystemTag method") {
                context("when tag is new") {
                    beforeEach {
                        device.addSystemTag(name: DeviceSpec.TestNameTag, value: DeviceSpec.TestValueTag)
                    }
                    
                    it("add the tag to tags array and has correct type.") {
                        expect(device.tags?[DeviceSpec.TestNameTag]).toNot(beNil())
                        expect(device.tags?[DeviceSpec.TestNameTag]!.value).to(equal(DeviceSpec.TestValueTag))
                        expect(device.tags?[DeviceSpec.TestNameTag]!.type).to(equal("000000000000000000000001"))
                    }
                }
            }
            
            describe("its addTags method") {
                let numberOfTags = 3
                var manyTags: [[String: String]] = []
                var i = 0
                while i < numberOfTags {
                    manyTags.append(["\(DeviceSpec.TestNameTag)\(i)": "\(DeviceSpec.TestValueTag)\(i)"])
                    i += 1
                }
                
                beforeEach {
                    device.addTags(tags: manyTags)
                }
                
                it("add all tags") {
                    expect(device.tags!.count).to(equal(numberOfTags))
                }
            }
            
            describe("its removeTag method") {
                var resultRemoveTag: Tag?
                
                context("when there are no tags") {
                    beforeEach {
                        resultRemoveTag = device.removeTag(name: DeviceSpec.TestNameTag)
                    }
                    
                    it("returns nil") {
                        expect(resultRemoveTag).to(beNil())
                    }
                }
                
                context("when the tag exists") {
                    beforeEach {
                        device.addTag(name: DeviceSpec.TestNameTag, value: DeviceSpec.TestValueTag)
                        resultRemoveTag = device.removeTag(name: DeviceSpec.TestNameTag)
                    }
                    
                    it("remove the tag.") {
                        expect(device.tags?[DeviceSpec.TestNameTag]).to(beNil())
                    }
                    
                    it("returns the tag removed") {
                        expect(resultRemoveTag).toNot(beNil())
                        expect(resultRemoveTag?.name).to(equal(DeviceSpec.TestNameTag))
                    }
                }
            }
        }
    }
}
