//
//  PaginatedModulesSpec.swift
//  Halo
//
//  Created by Miguel López on 27/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class PaginatedModulesSpec : BaseSpec {
    
    override func spec() {
        super.spec()
        
        describe("A PaginatedModule") {
            var paginatedModule: PaginatedModules!
            
            describe("its constructor method") {
                context("with a NSCoder") {
                    var paginatedModuleRestored: PaginatedModules?
                    
                    beforeEach {
                        // Save to temp file.
                        let path = NSTemporaryDirectory()
                        let locToSave = path.appending("testPaginatedModule")
                        paginatedModule = PaginatedModules(paginationInfo: MockPaginationInfo.createPaginationInfo(), modules: [MockModule.createFromJson(OHPathForFile("module_without_tags_with_isSingle.json", type(of: self))!)!])
                        NSKeyedArchiver.archiveRootObject(paginatedModule, toFile: locToSave)
                        paginatedModuleRestored = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? PaginatedModules
                    }
                    
                    it("works") {
                        expect(paginatedModuleRestored).toNot(beNil())
                        expect(paginatedModuleRestored?.paginationInfo).toNot(beNil())
                        expect(paginatedModuleRestored?.modules.count).to(equal(1))
                    }
                }
            }
        }
    }
    
}
