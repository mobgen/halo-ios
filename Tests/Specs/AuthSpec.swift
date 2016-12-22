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
import Foundation
@testable import Halo

class AuthSpec: BaseSpec {
    
    lazy var testAuthProfile: MockAuthProfile = {
        return MockAuthProfile(email: "account@mobgen.com",
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
        
        afterSuite {
            OHHTTPStubs.removeAllStubs()
        }
        
        describe("Login with Halo") {
            
            afterEach {
                OHHTTPStubs.removeAllStubs()
            }
            
            context("when user is registered") {
                var user: User?
                var error: NSError?
                var authProfileStored: AuthProfile?
                
                context("and server returns a successful response") {
                    beforeEach {
                        stub(condition: isPath("/api/segmentation/identified/login")) { _ in
                            let stubPath = OHPathForFile("login_success.json", type(of: self))
                            return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
                        }.name = "Successful login stub"
                        
                        waitUntil { done in
                            Manager.auth.login(authProfile: self.testAuthProfile) { (userResponse, errorResponse) in
                                user = userResponse
                                error = errorResponse
                                authProfileStored = MockAuthProfile.loadProfile()
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
                    
                    it("does not store AuthProfile") {
                        expect(authProfileStored).to(beNil())
                    }
                }
                
                context("and server returns a successful response but a nil user") {
                    beforeEach {
                        stub(condition: isPath("/api/segmentation/identified/login")) { _ in
                            let stubPath = OHPathForFile("login_success_nil_user.json", type(of: self))
                            return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
                            }.name = "Successful login stub"
                        
                        waitUntil { done in
                            Manager.auth.login(authProfile: self.testAuthProfile, stayLoggedIn: false) { (userResponse, errorResponse) in
                                user = userResponse
                                error = errorResponse
                                authProfileStored = MockAuthProfile.loadProfile()
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
                    
                    it("returns a nil User") {
                        expect(user).to(beNil())
                    }
                    
                    it("returns an error") {
                        expect(error).toNot(beNil())
                    }
                    
                    it("no user is logged in") {
                        expect(Manager.auth.currentUser).to(beNil())
                    }
                    
                    it("does not store AuthProfile") {
                        expect(authProfileStored).to(beNil())
                    }
                }
            }
            
            context("with a registered user and stayLoggedIn is true") {
                var user: User?
                var authProfileStored: AuthProfile?
                
                beforeEach {
                    stub(condition: isPath("/api/segmentation/identified/login")) { _ in
                        let stubPath = OHPathForFile("login_success.json", type(of: self))
                        return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
                    }.name = "Successful login stub"
                }
                
                context("using stayLoggedIn from method") {
                    beforeEach {
                        waitUntil { done in
                            Manager.auth.login(authProfile: self.testAuthProfile, stayLoggedIn: true) { (userResponse, _) in
                                user = userResponse
                                authProfileStored = MockAuthProfile.loadProfile()
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
                    
                    it("sets currentUser with user logged in") {
                        expect(Manager.auth.currentUser).to(equal(user))
                    }
                    
                    it("stores AuthProfile with same email") {
                        expect(authProfileStored).toNot(beNil())
                        expect(authProfileStored?.email).to(equal(self.testAuthProfile.email))
                    }
                }
                
                context("using stayLoggedIn property of AuthManager") {
                    beforeEach {
                        Manager.auth.stayLoggedIn = true
                        waitUntil { done in
                            Manager.auth.login(authProfile: self.testAuthProfile) { (userResponse, _) in
                                user = userResponse
                                authProfileStored = MockAuthProfile.loadProfile()
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
                    
                    it("sets currentUser with user logged in") {
                        expect(Manager.auth.currentUser).to(equal(user))
                    }
                    
                    it("stores AuthProfile with same email") {
                        expect(authProfileStored).toNot(beNil())
                        expect(authProfileStored?.email).to(equal(self.testAuthProfile.email))
                    }
                }
            }
        
            context("with a user not registered") {
                var user: User?
                var error: Error?
                
                beforeEach {
                    stub(condition: isPath("/api/segmentation/identified/login")) { _ in
                        let stubPath = OHPathForFile("login_error.json", type(of: self))
                        return fixture(filePath: stubPath!, status: 400, headers: ["Content-Type":"application/json"])
                    }.name = "Failed login stub"
                    
                    waitUntil { done in
                        Manager.auth.login(authProfile: self.testAuthProfile, stayLoggedIn: false) { (userResponse, errorResponse) in
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
                
                it("displays an error") {                    
                    expect(user).to(beNil())
                    expect(error).toNot(beNil())
                }
            }
        }
        
        describe("Logout") {
            
            beforeEach {
                stub(condition: isPath("/api/segmentation/identified/login")) { _ in
                    let stubPath = OHPathForFile("login_success.json", type(of: self))
                    return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
                }.name = "Successful login stub"
            }
            
            context("where user is not logged in") {
                var result: Bool?
                
                beforeEach {
                    waitUntil { done in
                        Manager.auth.logout { success in
                            result = success
                            done()
                        }
                    }
                }
                
                it("returns false") {
                    expect(result).to(beFalse())
                }
            }
            
            context("when user is logged in and credentials are stored") {
                var authProfileStored: AuthProfile?
                
                beforeEach {
                    waitUntil { done in
                        Manager.auth.login(authProfile: self.testAuthProfile, stayLoggedIn: true) { (_, _) in
                            done()
                        }
                    }
                    
                    waitUntil { done in
                        Manager.auth.logout { success in
                            authProfileStored = AuthProfile.loadProfile()
                            done()
                        }
                    }
                }
                
                it("removes user credentials from storage") {
                    expect(authProfileStored).to(beNil())
                }
                
                it("removes user") {
                    expect(Manager.auth.currentUser).to(beNil())
                }
            }
            
            context("when user is logged in and credentials are not stored") {
                beforeEach {
                    waitUntil { done in
                        Manager.auth.login(authProfile: self.testAuthProfile, stayLoggedIn: true) { (_, _) in
                            done()
                        }
                    }
                    
                    waitUntil { done in
                        Manager.auth.logout { success in
                            done()
                        }
                    }
                }
                
                it("removes user") {
                    expect(Manager.auth.currentUser).to(beNil())
                }
            }
        }
        
        describe("Register with Halo") {
            
            afterEach {
                OHHTTPStubs.removeAllStubs()
            }
            
            context("with a right AuthProfile and right UserProfile") {
                var userProfile: UserProfile?
                var error: NSError?
                
                beforeEach {
                    stub(condition: isPath("/api/segmentation/identified/register")) { _ in
                        let stubPath = OHPathForFile("register_success.json", type(of: self))
                        return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
                    }.name = "Successful register stub"
                    
                    waitUntil { done in
                        Manager.auth.register(authProfile: self.testAuthProfile,
                                              userProfile: self.testUserProfile) { (userProfileResponse, errorResponse) in
                            userProfile = userProfileResponse
                            error = errorResponse
                            done()
                        }
                    }
                }
                
                it("returns a valid UserProfile with same email") {
                    expect(userProfile).toNot(beNil())
                    expect(userProfile?.identifiedId).notTo(beNil())
                    expect(userProfile?.email).to(equal(self.testUserProfile.email))
                }
                
                it("returns a nil error") {
                    expect(error).to(beNil())
                }
            }
            
            context("with a wrong AuthProfile or wrong UserProfile") {
                var userProfile: UserProfile?
                var error: NSError?
                
                beforeEach {
                    stub(condition: isPath("/api/segmentation/identified/register")) { _ in
                        let stubPath = OHPathForFile("register_error.json", type(of: self))
                        return fixture(filePath: stubPath!, status: 400, headers: ["Content-Type":"application/json"])
                    }.name = "Failed register stub"
                    
                    waitUntil { done in
                        Manager.auth.register(authProfile: self.testAuthProfile,
                                              userProfile: self.testUserProfile) { (userProfileResponse, errorResponse) in
                                                userProfile = userProfileResponse
                                                error = errorResponse
                                                done()
                        }
                    }
                }
                
                it("returns a nil UserProfile") {
                    expect(userProfile).to(beNil())
                }
                
                it("returns an error") {
                    expect(error).toNot(beNil())
                }
            }
        }
    }
    
}
