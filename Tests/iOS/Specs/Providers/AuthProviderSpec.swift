//
//  AuthProviderSpec.swift
//  Halo
//
//  Created by Miguel López on 22/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class AuthProviderSpec : BaseSpec {
    
    lazy var testAuthProfile: MockAuthProfile = {
        return MockAuthProfile(email: "account@mobgen.com",
                               password: "password123",
                               deviceId: "randomdevicealias")
    }()
    
    override func spec() {
        
        let mockAuthProvider = MockAuthProvider()
        
        describe("an AuthProvider") {
            beforeEach {
                stub(condition: isPath("/api/segmentation/appuser")) { _ in
                    let stubPath = OHPathForFile("segmentation_appuser_success.json", type(of: self))
                    return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
                }.name = "Successful segmentation stub"
                
                stub(condition: isPath("/api/oauth/token")) { _ in
                    let stubPath = OHPathForFile("oauth_success.json", type(of: self))
                    return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
                }.name = "Successful oauth stub"
                
                Manager.core.appCredentials = Credentials(clientId: "halotestappclient", clientSecret: "halotestapppass")
                Manager.core.logLevel = .info
                Manager.core.startup()
                
                UserDefaults.standard.set(nil, forKey: "\(CoreConstants.keychainUserAuthKey)-\(Manager.core.environment.description)")
                UserDefaults.standard.synchronize()
            }
            
            afterEach {
                OHHTTPStubs.removeAllStubs()
            }
            
            describe("its authenticate method") {
                var user: User?
                var error: HaloError?
                
                context("when a valid authProfile is sent") {
                    beforeEach {
                        stub(condition: isPath("/api/segmentation/identified/login")) { _ in
                            let stubPath = OHPathForFile("login_success.json", type(of: self))
                            return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
                            }.name = "Successful login stub"
                        
                        waitUntil { done in
                            mockAuthProvider.authenticate(authProfile: self.testAuthProfile) { (userResponse, errorResponse) in
                                user = userResponse
                                error = errorResponse
                                done()
                            }
                        }
                    }
                    
                    afterEach {
                        waitUntil { done in
                            Manager.auth.logout { success in
                                done()
                            }
                        }
                    }
                    
                    it("returns a User with valid Token and UserProfile with same email") {
                        expect(user).toNot(beNil())
                        
                        let token = user?.token
                        expect(token).notTo(beNil())
                        expect(token?.isValid()).to(beTrue())
                        expect(token?.isExpired()).to(beFalse())
                        
                        let userProfile = user?.userProfile
                        expect(userProfile?.email).to(equal(self.testAuthProfile.email))
                    }
                    
                    it("user is logged in") {
                        expect(Manager.auth.currentUser).toNot(beNil())
                    }
                    
                    it("returns a nil error") {
                        expect(error).to(beNil())
                    }
                }
            }
        }
    }
}
