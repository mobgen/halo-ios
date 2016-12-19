//
//  AuthSpec.swift
//  Halo
//
//  Created by Miguel López on 15/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class AuthSpec: BaseSpec {
    
    lazy var testAuthProfile: AuthProfile = {
        return AuthProfile(email: "account@mobgen.com",
                           password: "password123",
                           deviceId: "randomdevicealias")
    }()
    
    lazy var testUserProfile: UserProfile = {
        return UserProfile(id: nil,
                           email: "account@mobgen.com",
                           name: "testName",
                           surname: "testSurname",
                           displayName: "testName testSurname",
                           profilePictureUrl: nil)
    }()
    
    override func spec() {
        
        super.spec()
        
        beforeSuite {
            Manager.core.appCredentials = Credentials(clientId: "halotestappclient", clientSecret: "halotestapppass")
            Manager.core.startup()
        }
        
        // MARK: TODO - Write test for recovering user.
        xdescribe("User exists already in keychain") {
            
            it("recover user") {
                
            }
            
        }
        
        describe("Login with Halo") {
            
            afterEach {
                OHHTTPStubs.removeAllStubs()
            }
            
            context("using email and password") {
                
                beforeEach {
                    
                    stub(condition: isPath("/api/segmentation/identified/login")) { _ in
                        let stubPath = OHPathForFile("login_success.json", type(of: self))
                        return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
                    }.name = "Successful login stub"
                    
                }
                
                it("logs in successfully") {
                    
                    waitUntil(timeout: 2) { done in
                        
                        Manager.auth.login(authProfile: self.testAuthProfile) { (userResponse, error) in
                            
                            // error == nil.
                            expect(error).to(beNil())
                            
                            let token = userResponse?.token
                            // token != nil.
                            expect(token).notTo(beNil())
                            // token is valid.
                            expect(token?.isValid()).to(beTrue())
                            // token is not expired.
                            expect(token?.isExpired()).to(beFalse())
                            
                            let userProfile = userResponse?.userProfile
                            // email is still the same.
                            expect(userProfile?.email).to(equal(self.testAuthProfile.email))
                            
                            done()
                        }
                    }
                    
                }
                
                // MARK: TODO - Write test for saving user after login.
                it("saves user in keychain") {
                    
                    
                }
                
            }
            
        }
        
        describe("Register with Halo") {
            
            afterEach {
                OHHTTPStubs.removeAllStubs()
            }
            
            beforeEach {
                
                stub(condition: isPath("/api/segmentation/identified/register")) { _ in
                    let stubPath = OHPathForFile("register_success.json", type(of: self))
                    return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
                }.name = "Successful register stub"
                
            }
            
            it("registers successfuly") {
                
                waitUntil { done in
                    
                    Manager.auth
                        .register(authProfile: self.testAuthProfile, userProfile: self.testUserProfile) { (userProfileResponse, error) in
                        
                        // error == nil.
                        expect(error).to(beNil())
                        // userProfileResponse != nil.
                        expect(userProfileResponse).notTo(beNil())
                        // identifiedId != nil.
                        expect(userProfileResponse?.identifiedId).notTo(beNil())
                        // email is still the same.
                        expect(userProfileResponse?.email).to(equal(self.testAuthProfile.email))
                        
                        done()
                    }
                }
                
            }
            
            // MARK: TODO - Write test for saving user after registration.
            xit("saves user in keychain") {
                
            }
            
        }
        
        // MARK: TODO - Write test for removing user after logout.
        xdescribe("Logout") {
            
            it("removes user from keychain") {
                
            }
            
        }
    }
    
}
