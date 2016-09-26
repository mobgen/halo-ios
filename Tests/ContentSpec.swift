//
//  GeneralContentSpec.swift
//  HaloSDK
//
//  Created by Borja on 04/09/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class ContentSpec : BaseSpec {

    override func spec() {
        
        describe("Retrieving all modules") {
            
            context("with pagination info") {
                
                beforeEach {
                    stub(isPath("/api/generalcontent/module")) { (request) -> OHHTTPStubsResponse in
                        let fixture = OHPathForFile("modules_success.json", self.dynamicType)
                        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Successful get modules stub"
                }
                
                it("works") {
                    var resp: PaginatedModules?
                    
                    waitUntil { done in
                        
                        Halo.Manager.core.getModules { response, result in
                            switch result {
                            case .Success(let data, _):
                                resp = data
                            case .Failure(let e):
                                NSLog("Error: \(e.localizedDescription)")
                            }
                            done()
                        }
                    }
                    
                    expect(resp).toNot(beNil())
                    
                    // Check pagination
                    let pag: PaginationInfo? = resp?.paginationInfo
                    expect(pag?.page).to(equal(1))
                    expect(pag?.limit).to(equal(10))
                    expect(pag?.offset).to(equal(0))
                    expect(pag?.totalItems).to(equal(6))
                    expect(pag?.totalPages).to(equal(1))
                }
            }
            
            context("with missing pagination info") {
                
                beforeEach {
                    stub(isPath("/api/generalcontent/module")) { (request) -> OHHTTPStubsResponse in
                        let fixture = OHPathForFile("modules_success_no_pagination.json", self.dynamicType)
                        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Successful get modules stub"
                }
                
                it("works") {
                    var resp: PaginatedModules?
                    
                    waitUntil { done in
                        
                        Halo.Manager.core.getModules { response, result in
                            switch result {
                            case .Success(let data, _):
                                resp = data
                            case .Failure(let e):
                                NSLog("Error: \(e.localizedDescription)")
                            }
                            done()
                        }
                    }
                    
                    expect(resp).toNot(beNil())
                    
                    // Check pagination
                    let pag: PaginationInfo? = resp?.paginationInfo
                    expect(pag?.page).to(equal(0))
                    expect(pag?.limit).to(equal(0))
                    expect(pag?.offset).to(equal(0))
                    expect(pag?.totalItems).to(equal(0))
                    expect(pag?.totalPages).to(equal(0))
                }
                
            }
        }
        
    }
    
}
