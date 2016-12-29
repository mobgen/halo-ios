//
//  MockUserProfile.swift
//  Halo
//
//  Created by Miguel López on 29/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
@testable import Halo

class MockUserProfile : UserProfile {
    
    static let TestId = "testId"
    static let TestEmail = "testEmail"
    static let TestProfilePictureUrl = "testProfilePictureUrl"
    static let TestDisplayName = "testDisplayName"
    static let TestName = "testName"
    static let TestSurname = "testSurname"
    
    static let TestDict = [
        UserProfile.Keys.Id: MockUserProfile.TestId,
        UserProfile.Keys.Email: MockUserProfile.TestEmail,
        UserProfile.Keys.PhotoUrl: MockUserProfile.TestProfilePictureUrl,
        UserProfile.Keys.DisplayName: MockUserProfile.TestDisplayName,
        UserProfile.Keys.Name: MockUserProfile.TestName,
        UserProfile.Keys.Surname: MockUserProfile.TestSurname,
    ]
    
    class func createUserProfile() -> UserProfile {
        return UserProfile(id: TestId, email: TestEmail, name: TestName, surname: TestSurname, displayName: TestDisplayName, profilePictureUrl: TestProfilePictureUrl)
    }
    
    class func createUserProfileWithDict() -> UserProfile {
        return UserProfile.fromDictionary(TestDict)
    }
}
