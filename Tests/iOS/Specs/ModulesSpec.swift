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
        
        describe("Retrieving all modules") {
            var resp: PaginatedModules?
            
            beforeEach {
                Manager.core.appCredentials = Credentials(clientId: "halotestappclient", clientSecret: "halotestapppass")
                Manager.core.logLevel = .info
                Manager.core.startup(UIApplication())
            }
            
            afterEach {
                Router.appToken = nil
                Router.userToken = nil
            }
            
            context("when pagination is on") {
                beforeEach {
                    stub(condition: isPath("/api/generalcontent/module")) { _ in
                        let filePath = OHPathForFile("module_list_success_paginated.json", type(of: self))
                        return fixture(filePath: filePath!, status: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Successful get modules stub"
                    
                    waitUntil { done in
                        Manager.core.getModules { (_, result) in
                            switch result {
                            case .success(let data, _):
                                resp = data
                            default:
                                break
                            }
                            done()
                        }
                    }
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
                }
                
                it("works") {
                    expect(resp).toNot(beNil())
                    
                    // Check pagination
                    let pag: PaginationInfo? = resp?.paginationInfo
                    expect(pag?.page).to(equal(1))
                    expect(pag?.limit).to(equal(10))
                    expect(pag?.offset).to(equal(0))
                    expect(pag?.totalItems).to(equal(2))
                    expect(pag?.totalPages).to(equal(1))
                    
                    expect(resp?.modules.count).to(equal(2))
                    
                    // Check some parsed values of the first module
                    let module: Halo.Module? = resp?.modules.first!
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
            
            context("when pagination is off") {
                beforeEach {
                    stub(condition: isPath("/api/generalcontent/module")) { _ in
                        let filePath = OHPathForFile("module_list_success_not_paginated.json", type(of: self))
                        return fixture(filePath: filePath!, status: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Successful get modules stub"
                    
                    waitUntil { done in
                        Halo.Manager.core.getModules { response, result in
                            switch result {
                            case .success(let data, _):
                                resp = data
                            default:
                                break
                            }
                            done()
                        }
                    }
                }
                
                afterEach {
                    OHHTTPStubs.removeAllStubs()
                }
                
                it("works") {
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
