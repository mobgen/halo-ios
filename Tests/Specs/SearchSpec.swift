//
//  SearchSpec.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 27/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class SearchSpec: BaseSpec {
    
    override func spec() {
        
        super.spec()
        
        let cont = Halo.Manager.content
        
        describe("The search call") {
            
            context("without parameters") {
                
                var paginated: PaginatedContentInstances?
                
                beforeEach {
                    stub(condition: isPath("/api/generalcontent/instance/search")) { (request) -> OHHTTPStubsResponse in
                        let fixture = OHPathForFile("simple_search_success.json", type(of: self))
                        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type": "application/json"])
                    }.name = "Search stub"
                    
                    waitUntil { done in
                        cont.search(query: SearchQuery()) { response, result in
                            
                            switch result {
                            case .success(let data, _):
                                paginated = data
                            default: break
                            }
                            done()
                        }
                    }
                }
            
                afterEach {
                    OHHTTPStubs.removeAllStubs()
                }
                
                it("works") {
                    // Check pagination
                    let pag = paginated?.paginationInfo
                    
                    expect(pag?.page).to(equal(1))
                    expect(pag?.limit).to(equal(10))
                    expect(pag?.offset).to(equal(0))
                    expect(pag?.totalItems).to(equal(8846))
                    expect(pag?.totalPages).to(equal(885))
                    
                    // Check instances
                    expect(paginated?.instances.count).to(equal(10))
                    
                    // Check first instance
                    let instance: ContentInstance? = paginated?.instances.first
                    
                    expect(instance?.isPublished()).to(beTrue())
                    expect(instance?.isDeleted()).to(beFalse())
                    expect(instance?.isRemoved()).to(beFalse())
                    
                }
                
            }
            
        }
        
    }
    
}
