//
//  UserProfileSpec.swift
//  Halo
//
//  Created by Miguel López on 29/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
@testable import Halo

class UserProfileSpec : BaseSpec {
    
    override func spec() {
        super.spec()
        
        describe("a UserProfile") {
            var userProfile: UserProfile!
            
            describe("its constructor method") {
                context("with values") {
                    beforeEach {
                        userProfile = MockUserProfile.createUserProfile()
                    }
                    
                    it("works") {
                        expect(userProfile).toNot(beNil())
                        expect(userProfile.identifiedId).to(equal(MockUserProfile.TestId))
                        expect(userProfile.email).to(equal(MockUserProfile.TestEmail))
                        expect(userProfile.name).to(equal(MockUserProfile.TestName))
                        expect(userProfile.surname).to(equal(MockUserProfile.TestSurname))
                        expect(userProfile.displayName).to(equal(MockUserProfile.TestDisplayName))
                        expect(userProfile.profilePictureUrl).to(equal(MockUserProfile.TestProfilePictureUrl))
                    }
                }
                
                context("with a NSCoder") {
                    var userProfileRestored: UserProfile?
                    
                    beforeEach {
                        // Save to temp file.
                        let path = NSTemporaryDirectory()
                        let locToSave = path.appending("testUserProfile")
                        userProfile = MockUserProfile.createUserProfile()
                        NSKeyedArchiver.archiveRootObject(userProfile, toFile: locToSave)
                        userProfileRestored = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? UserProfile
                    }
                    
                    it("works") {
                        expect(userProfileRestored).toNot(beNil())
                        expect(userProfileRestored!.identifiedId).to(equal(MockUserProfile.TestId))
                        expect(userProfileRestored!.email).to(equal(MockUserProfile.TestEmail))
                        expect(userProfileRestored!.name).to(equal(MockUserProfile.TestName))
                        expect(userProfileRestored!.surname).to(equal(MockUserProfile.TestSurname))
                        expect(userProfileRestored!.displayName).to(equal(MockUserProfile.TestDisplayName))
                        expect(userProfileRestored!.profilePictureUrl).to(equal(MockUserProfile.TestProfilePictureUrl))
                    }
                }
            }
            
            describe("its fromDictionary method") {
                beforeEach {
                    userProfile = MockUserProfile.createUserProfileWithDict()
                }
                
                it("works") {
                    expect(userProfile).toNot(beNil())
                    expect(userProfile.identifiedId).to(equal(MockUserProfile.TestId))
                    expect(userProfile.email).to(equal(MockUserProfile.TestEmail))
                    expect(userProfile.name).to(equal(MockUserProfile.TestName))
                    expect(userProfile.surname).to(equal(MockUserProfile.TestSurname))
                    expect(userProfile.displayName).to(equal(MockUserProfile.TestDisplayName))
                    expect(userProfile.profilePictureUrl).to(equal(MockUserProfile.TestProfilePictureUrl))
                }
            }
            
            describe("its toDictionary method") {
                var dict: [String: String]?
                
                beforeEach {
                    userProfile = MockUserProfile.createUserProfile()
                    dict = userProfile.toDictionary()
                }
                
                it("works") {
                    expect(dict).toNot(beNil())
                    expect(dict![UserProfile.Keys.Id]).to(equal(MockUserProfile.TestId))
                    expect(dict![UserProfile.Keys.Email]).to(equal(MockUserProfile.TestEmail))
                    expect(dict![UserProfile.Keys.Name]).to(equal(MockUserProfile.TestName))
                    expect(dict![UserProfile.Keys.Surname]).to(equal(MockUserProfile.TestSurname))
                    expect(dict![UserProfile.Keys.DisplayName]).to(equal(MockUserProfile.TestDisplayName))
                    expect(dict![UserProfile.Keys.PhotoUrl]).to(equal(MockUserProfile.TestProfilePictureUrl))
                }
            }
            
            describe("its property displayName") {
                context("when displayName is nil") {
                    beforeEach {
                        userProfile = MockUserProfile.createUserProfile()
                        userProfile.displayName = nil
                    }
                    
                    it("returns the property name") {
                        expect(userProfile).toNot(beNil())
                        expect(userProfile.displayName).to(equal(MockUserProfile.TestName))
                    }
                }
            }
        }
    }
    
}
