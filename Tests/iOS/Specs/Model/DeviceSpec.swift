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
    
    // MARK : Constants - Testing constructor.
    
    static let TestId = "testId"
    static let TestAppId = 1
    static let TestEmail = "test@email.com"
    static let TestAlias = "testAlias"
    static let TestDevices = "devices"
    static let TestTags = "tags"
    static let TestCreatedAt = "createdAt"
    static let TestUpdatedAt = "updatedAt"
    
    // MARK : Constants - Testing devices.
    
    static let TestPlatformDeviceInfo = "testPlatform"
    static let TestTokenDeviceInfo = "testToken"
    
    // MARK : Constants - Testing tags.
    
    static let TestNameTag = "testNameTag"
    static let TestValueTag = "testValueTag"
    static let TestValueUpdatedTag = "testValueUpdatedTag"
    
    override func spec() {
        describe("A device") {
            var device: Device!
            
            // Test data.
            let deviceInfo = DeviceInfo(platform: DeviceSpec.TestPlatformDeviceInfo, token: DeviceSpec.TestTokenDeviceInfo)
            let createdAt = Date(timeIntervalSinceNow: -3000)
            let updatedAt = Date()
            
            // Creating testing tags.
            let numberOfTags = 3
            var manyTags: [Tag] = []
            var i = 0
            while i < numberOfTags {
                manyTags.append(Tag(name: "\(DeviceSpec.TestNameTag)\(i)", value: "\(DeviceSpec.TestValueTag)\(i)", type: "testTypeTag"))
                i += 1
            }
            
            beforeEach {
                // Create a new device.
                device = Device.fromDictionary(dict: [
                    Device.Keys.Id: DeviceSpec.TestId,
                    Device.Keys.AppId: DeviceSpec.TestAppId,
                    Device.Keys.Alias: DeviceSpec.TestAlias,
                    Device.Keys.Email: DeviceSpec.TestEmail,
                    Device.Keys.Devices: [deviceInfo.toDictionary()],
                    Device.Keys.Tags: manyTags.map { return $0.toDictionary() } ,
                    Device.Keys.CreatedAt: createdAt.timeIntervalSince1970 * 1000,
                    Device.Keys.UpdatedAt: updatedAt.timeIntervalSince1970 * 1000
                ])
            }
            
            describe("its constructor method") {
                context("with a NSCoder") {
                    var deviceRestored: Device?
                    
                    beforeEach {
                        // Save to temp file.
                        let path = NSTemporaryDirectory()
                        let locToSave = path.appending("testDevice")
                        NSKeyedArchiver.archiveRootObject(device, toFile: locToSave)
                        deviceRestored = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? Device
                    }
                    
                    it("works") {
                        expect(deviceRestored).toNot(beNil())
                        expect(deviceRestored!.id).to(equal(DeviceSpec.TestId))
                        expect(deviceRestored!.appId).to(equal(DeviceSpec.TestAppId))
                        expect(deviceRestored!.alias).to(equal(DeviceSpec.TestAlias))
                        expect(deviceRestored!.email).to(equal(DeviceSpec.TestEmail))
                        expect(deviceRestored!.info?.platform).to(equal(deviceInfo.platform))
                        expect(deviceRestored!.info?.token).to(equal(deviceInfo.token))
                        expect(deviceRestored!.tags?.count).to(equal(manyTags.count))
                        expect(deviceRestored!.createdAt?.timeIntervalSinceNow).to(beCloseTo(createdAt.timeIntervalSinceNow))
                        expect(deviceRestored!.updatedAt?.timeIntervalSinceNow).to(beCloseTo(updatedAt.timeIntervalSinceNow))
                    }
                }
            }
            
            describe("its toDictionary method") {
                var dictFromDevice: [String: Any]?
                
                beforeEach {
                    dictFromDevice = device.toDictionary()
                }
                
                it("works") {
                    expect(dictFromDevice).toNot(beNil())
                    expect(dictFromDevice![Device.Keys.Id] as? String).to(equal(DeviceSpec.TestId))
                    expect(dictFromDevice![Device.Keys.AppId] as? Int).to(equal(DeviceSpec.TestAppId))
                    expect(dictFromDevice![Device.Keys.Alias] as? String).to(equal(DeviceSpec.TestAlias))
                    expect(dictFromDevice![Device.Keys.Email] as? String).to(equal(DeviceSpec.TestEmail))
                    expect((dictFromDevice![Device.Keys.Devices] as? [[String: AnyObject]])?.first?[DeviceInfo.Keys.Platform] as? String).to(equal(deviceInfo.platform))
                    expect((dictFromDevice![Device.Keys.Devices] as? [[String: AnyObject]])?.first?[DeviceInfo.Keys.Token] as? String).to(equal(deviceInfo.token))
                    expect((dictFromDevice![Device.Keys.Tags] as? [AnyObject])?.count).to(equal(manyTags.count))
                    expect(dictFromDevice![Device.Keys.CreatedAt] as? Double).to(beCloseTo(createdAt.timeIntervalSince1970 * 1000))
                    expect(dictFromDevice![Device.Keys.UpdatedAt] as? Double).to(beCloseTo(updatedAt.timeIntervalSince1970 * 1000))
                }
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
                var manyTags: [String: String] = [:]
                var i = 0
                
                beforeEach {
                    device = Device()
                    while i < numberOfTags {
                        manyTags["\(DeviceSpec.TestNameTag)\(i)"] = "\(DeviceSpec.TestValueTag)\(i)"
                        i += 1
                    }
                    device.addTags(tags: manyTags)
                }
                
                it("add all tags") {
                    expect(device.tags!.count).to(equal(numberOfTags))
                }
            }
            
            describe("its removeTag method") {
                var resultRemoveTag: Tag?
                
                beforeEach {
                    device = Device()
                }
                
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
