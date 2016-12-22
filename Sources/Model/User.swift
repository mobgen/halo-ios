//
//  User.swift
//  HaloSocial
//
//  Created by Borja Santos-Díez on 17/11/16.
//  Copyright © 2016 Mobgen Technology. All rights reserved.
//

import Foundation

@objc(HaloUser)
public class User: NSObject, NSCoding {
    
    struct Keys {
        static let Token = "token"
        static let UserProfile = "user"
    }
    
    var userProfile: UserProfile
    internal (set) public var token: Token
    
    public override var debugDescription: String {
        return "[User] Email: \(userProfile.email)"
    }
    
    init(profile: UserProfile, token: Token) {
        self.userProfile = profile
        self.token = token
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        userProfile = aDecoder.decodeObject(forKey: Keys.UserProfile) as? UserProfile ?? UserProfile()
        token = aDecoder.decodeObject(forKey: Keys.Token) as? Token ?? Token()
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(userProfile, forKey: Keys.UserProfile)
        aCoder.encode(token, forKey: Keys.Token)
    }
    
    // MARK: Class functions
    
    public class func fromDictionary(_ dict: [String: Any]) -> User? {
        var t: Token
        if let tokenDict = dict[Keys.Token] as? [String: Any] {
            t = Token.fromDictionary(tokenDict)
        } else {
            return nil
        }
        
        var up: UserProfile
        if let userProfileDict = dict[Keys.UserProfile] as? [String: Any] {
            up = UserProfile.fromDictionary(userProfileDict)
        } else {
            return nil
        }
        
        return User(profile: up, token: t)
    }
    
}
