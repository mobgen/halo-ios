//
//  ModuleSpec.swift
//  Halo
//
//  Created by Miguel López on 27/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class ModuleSpec : BaseSpec {
    
    override func spec() {
        super.spec()
        
        describe("A Module") {
            var module: Module!
            
            describe("its fromDictionary method") {
                context("with a dictionary with empty values") {
                    beforeEach {
                        module = Module.fromDictionary(dict: [:])
                    }
                    
                    it("works") {
                        expect(module).toNot(beNil())
                        expect(module.id).to(beNil())
                        expect(module.customerId).to(beNil())
                        expect(module.name).to(beNil())
                        expect(module.isSingle).to(beFalse())
                        expect(module.createdBy).to(beNil())
                        expect(module.updatedBy).to(beNil())
                        expect(module.deletedBy).to(beNil())
                        expect(module.createdAt).to(beNil())
                        expect(module.updatedAt).to(beNil())
                        expect(module.deletedAt).to(beNil())
                        expect(module.tags.count).to(equal(0))
                    }
                }
                
                context("with a dictionary with values") {
                    beforeEach {
                        module = MockModule.createFromJson(OHPathForFile("module_without_tags_with_isSingle.json", type(of: self))!)
                    }
                    
                    it("works") {
                        expect(module).toNot(beNil())
                        expect(module.id).to(equal(MockModule.TestId))
                        expect(module.customerId).to(equal(MockModule.TestCustomerId))
                        expect(module.name).to(equal(MockModule.TestName))
                        expect(module.isSingle).to(equal(MockModule.TestIsSingle))
                        expect(module.createdBy).to(equal(MockModule.TestCreatedBy))
                        expect(module.updatedBy).to(equal(MockModule.TestUpdatedBy))
                        expect(module.deletedBy).to(equal(MockModule.TestDeletedBy))
                        expect(module.createdAt).to(equal(MockModule.TestCreatedAt))
                        expect(module.updatedAt).to(equal(MockModule.TestUpdatedAt))
                        expect(module.deletedAt).to(equal(MockModule.TestDeletedAt))
                        expect(module.tags.count).to(equal(0))
                    }
                }
            }
            
            describe("its constructor method") {
                context("with a NSCoder") {
                    var moduleRestored: Module?
                    
                    context("with some tags and without isSingle") {
                        beforeEach {
                            // Save to temp file.
                            let path = NSTemporaryDirectory()
                            let locToSave = path.appending("testModule")
                            module = MockModule.createFromJson(OHPathForFile("module_with_tags_without_isSingle.json", type(of: self))!)
                            NSKeyedArchiver.archiveRootObject(module, toFile: locToSave)
                            moduleRestored = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? Module
                        }
                        
                        it("works") {
                            expect(moduleRestored).toNot(beNil())
                            expect(moduleRestored!.id).to(equal(MockModule.TestId))
                            expect(moduleRestored!.customerId).to(equal(MockModule.TestCustomerId))
                            expect(moduleRestored!.name).to(equal(MockModule.TestName))
                            expect(moduleRestored!.isSingle).to(beFalse())
                            expect(moduleRestored!.createdBy).to(equal(MockModule.TestCreatedBy))
                            expect(moduleRestored!.updatedBy).to(equal(MockModule.TestUpdatedBy))
                            expect(moduleRestored!.deletedBy).to(equal(MockModule.TestDeletedBy))
                            expect(moduleRestored!.createdAt).to(equal(MockModule.TestCreatedAt))
                            expect(moduleRestored!.updatedAt).to(equal(MockModule.TestUpdatedAt))
                            expect(moduleRestored!.deletedAt).to(equal(MockModule.TestDeletedAt))
                            expect(moduleRestored!.tags.count).to(equal(2))
                        }
                    }
                    
                    context("without tags but with isSingle") {
                        beforeEach {
                            // Save to temp file.
                            let path = NSTemporaryDirectory()
                            let locToSave = path.appending("testModule")
                            module = MockModule.createFromJson(OHPathForFile("module_without_tags_with_isSingle.json", type(of: self))!)
                            NSKeyedArchiver.archiveRootObject(module, toFile: locToSave)
                            moduleRestored = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? Module
                        }
                        
                        it("works") {
                            expect(moduleRestored).toNot(beNil())
                            expect(moduleRestored!.id).to(equal(MockModule.TestId))
                            expect(moduleRestored!.customerId).to(equal(MockModule.TestCustomerId))
                            expect(moduleRestored!.name).to(equal(MockModule.TestName))
                            expect(moduleRestored!.isSingle).to(equal(MockModule.TestIsSingle))
                            expect(moduleRestored!.createdBy).to(equal(MockModule.TestCreatedBy))
                            expect(moduleRestored!.updatedBy).to(equal(MockModule.TestUpdatedBy))
                            expect(moduleRestored!.deletedBy).to(equal(MockModule.TestDeletedBy))
                            expect(moduleRestored!.createdAt).to(equal(MockModule.TestCreatedAt))
                            expect(moduleRestored!.updatedAt).to(equal(MockModule.TestUpdatedAt))
                            expect(moduleRestored!.deletedAt).to(equal(MockModule.TestDeletedAt))
                            expect(moduleRestored!.tags.count).to(equal(0))
                        }
                    }
                }
            }
        }
    }
    
}
