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

class ModulesSpec : BaseSpec {

    override func spec() {
        
        super.spec()
        
        describe("Retrieving all modules") {
            
            context("paginated") {
                
                beforeEach {
                    stub(isPath("/api/generalcontent/module")) { (request) -> OHHTTPStubsResponse in
                        let fixture = OHPathForFile("module_list_success_paginated.json", type(of: self))
                        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Successful get modules stub"
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
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
                    expect(pag?.totalItems).to(equal(2))
                    expect(pag?.totalPages).to(equal(1))
                    
                    expect(resp?.modules.count).to(equal(2))
                    
                    let module: Halo.Module? = resp?.modules.first!
                    
                    // Check some parsed values of the first module
                    expect(module?.id).to(equal("000000000000000000000004"))
                    expect(module?.customerId).to(equal(1))
                    expect(module?.name).to(equal("News"))
                    expect(module?.isSingle).to(beFalse())
                    expect(module?.createdBy).to(equal("Admin"))
                    expect(module?.updatedBy).to(equal("undefined"))
                    expect(module?.deletedAt).to(beNil())
                    expect(module?.deletedBy).to(beNil())
                    
                }
            }
            
            context("not paginated") {
                
                beforeEach {
                    stub(isPath("/api/generalcontent/module")) { (request) -> OHHTTPStubsResponse in
                        let fixture = OHPathForFile("module_list_success_not_paginated.json", type(of: self))
                        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Successful get modules stub"
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
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
                    expect(pag?.limit).to(equal(2))
                    expect(pag?.offset).to(equal(0))
                    expect(pag?.totalItems).to(equal(2))
                    expect(pag?.totalPages).to(equal(1))
                    
                    expect(resp?.modules.count).to(equal(2))
                }
                
            }
        }
        
    }
    
}
