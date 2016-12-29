//
//  UserSpec.swift
//  Halo
//
//  Created by Miguel López on 29/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
@testable import Halo

class UserSpec : BaseSpec {
    
    override func spec() {
        super.spec()
        
        var user: User?
        
        describe("A User") {
            describe("its constructor method") {
                context("with a NSCoder") {
                    var userRestored: User?
                    
                    beforeEach {
                        // Save to temp file.
                        let path = NSTemporaryDirectory()
                        let locToSave = path.appending("testUser")
                        user = MockUser.createUser()
                        NSKeyedArchiver.archiveRootObject(user!, toFile: locToSave)
                        userRestored = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? User
                    }
                    
                    it("works") {
                        expect(userRestored).toNot(beNil())
                        expect(userRestored!.userProfile.identifiedId).to(equal(MockUserProfile.TestId))
                        expect(userRestored!.userProfile.email).to(equal(MockUserProfile.TestEmail))
                        expect(userRestored!.userProfile.name).to(equal(MockUserProfile.TestName))
                        expect(userRestored!.userProfile.surname).to(equal(MockUserProfile.TestSurname))
                        expect(userRestored!.userProfile.displayName).to(equal(MockUserProfile.TestDisplayName))
                        expect(userRestored!.token.token).to(equal(MockToken.TestAccessToken))
                        expect(userRestored!.token.refreshToken).to(equal(MockToken.TestRefreshToken))
                        expect(userRestored!.token.tokenType).to(equal(MockToken.TestTokenType))
                        expect(userRestored!.token.expirationDate).to(beLessThan(Date().addingTimeInterval(MockToken.TestExpiresIn.doubleValue/1000)))
                    }
                }
            }
            
            describe("its fromDictionary method") {
                beforeEach {
                    user = User.fromDictionary(MockUser.TestDict)
                }
                
                it("works") {
                    expect(user).toNot(beNil())
                    expect(user!.userProfile.identifiedId).to(equal(MockUserProfile.TestId))
                    expect(user!.userProfile.email).to(equal(MockUserProfile.TestEmail))
                    expect(user!.userProfile.name).to(equal(MockUserProfile.TestName))
                    expect(user!.userProfile.surname).to(equal(MockUserProfile.TestSurname))
                    expect(user!.userProfile.displayName).to(equal(MockUserProfile.TestDisplayName))
                    expect(user!.token.token).to(equal(MockToken.TestAccessToken))
                    expect(user!.token.refreshToken).to(equal(MockToken.TestRefreshToken))
                    expect(user!.token.tokenType).to(equal(MockToken.TestTokenType))
                    expect(user!.token.expirationDate).to(beLessThan(Date().addingTimeInterval(MockToken.TestExpiresIn.doubleValue/1000)))
                }
            }
        }
    }
    
}
