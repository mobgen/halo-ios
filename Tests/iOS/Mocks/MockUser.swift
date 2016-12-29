//
//  MockUser.swift
//  Halo
//
//  Created by Miguel López on 29/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
@testable import Halo

class MockUser : User {
    
    static let TestDict = [
        User.Keys.UserProfile: MockUserProfile.TestDict,
        User.Keys.Token: MockToken.TestDict
    ]
    
    class func createUser() -> User {
        return User(profile: MockUserProfile.createUserProfile(), token: MockToken.createFromJson()!)
    }
    
}
