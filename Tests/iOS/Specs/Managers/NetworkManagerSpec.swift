//
//  NetworkManagerSpec.swift
//  Halo
//
//  Created by Miguel López on 22/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import Foundation
import OHHTTPStubs
@testable import Halo

class NetworkManagerSpec : BaseSpec {
    
    override func spec() {
        super.spec()
        
        describe("NetworkManager") {
            
            beforeEach {
                Manager.core.appCredentials = Credentials(clientId: "halotestappclient", clientSecret: "halotestapppass")
                Manager.core.logLevel = .info
                Manager.core.startup()
            }
            
            afterEach {                
                Router.appToken = nil
                Router.userToken = nil
            }
            
            context("its registerAddon method") {
                let testNetworkAddon = MockNetworkAddon()
                
                beforeEach {
                    Manager.network.registerAddon(addon: testNetworkAddon)
                }
                
                it("add the NetworkAddon to addons property") {
                    expect(Manager.network.addons.map( { return $0.addonName } )).to(contain(testNetworkAddon.addonName))
                }
            }
            
            context("its authenticate method") {
                context("when there are no credentials") {
                    var result: Result<Token>!
                    
                    beforeEach {
                        waitUntil { done in
                            Manager.core.appCredentials = nil
                            Manager.network.authenticate(mode: .app) { (_, resultResponse) in
                                result = resultResponse
                                done()
                            }
                        }
                    }
                    
                    it("returns a failure") {
                        switch (result!) {
                        case .success(_, _):
                            XCTFail("should be failure, not success")
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
}
