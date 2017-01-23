//
//  PaginatedInstancesSpec.swift
//  Halo
//
//  Created by Miguel López on 27/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
@testable import Halo

class PaginatedContentInstancesSpec : BaseSpec {
    
    override func spec() {
        describe("its constructor method") {
            var paginatedContentInstances: PaginatedContentInstances!
            
            describe("with a NSCoder") {
                var paginatedContentInstancesRestored: PaginatedContentInstances?
                
                beforeEach {
                    // Save to temp file.
                    let path = NSTemporaryDirectory()
                    let locToSave = path.appending("testPaginatedContentInstances")
                    paginatedContentInstances = PaginatedContentInstances(paginationInfo: MockPaginationInfo.createPaginationInfo(),
                                                                          instances: [MockContentInstance.createFromJson()!])
                    NSKeyedArchiver.archiveRootObject(paginatedContentInstances, toFile: locToSave)
                    paginatedContentInstancesRestored = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? PaginatedContentInstances
                }
                
                it("works") {
                    expect(paginatedContentInstancesRestored).toNot(beNil())
                    expect(paginatedContentInstancesRestored?.paginationInfo).toNot(beNil())
                    expect(paginatedContentInstancesRestored?.instances.count).to(equal(1))
                }
            }
        }
    }
    
}
