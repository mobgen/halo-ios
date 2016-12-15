//
//  UserProfile.swift
//  HaloSocial
//
//  Created by Borja Santos-Díez on 17/11/16.
//  Copyright © 2016 Mobgen Technology. All rights reserved.
//

import Foundation

@objc(HaloUserProfile)
public class UserProfile: NSObject {
    
    struct Keys {
        static let Id = "id"
        static let Email = "email"
        static let Name = "name"
        static let Surname = "surname"
        static let DisplayName = "displayName"
        static let PhotoUrl = "photoUrl"
    }
    
    var identifiedId: String?
    var email: String
    var profilePictureUrl: String?
    var _displayName: String?
    var displayName: String? {
        get {
            return _displayName ?? self.name
        }
        set {
            _displayName = newValue
        }
    }
    var name: String
    var surname: String
    
    public override var debugDescription: String {
        return "[UserProfile] Id: \(identifiedId) | Email: \(email) | DisplayName: \(displayName)"
    }
    
    public init(id: String?, email: String, name: String, surname: String, displayName: String?, profilePictureUrl: String?) {
        self.email = email
        self.name = name
        self.surname = surname
        super.init()
        self.identifiedId = id
        self.displayName = displayName
        self.profilePictureUrl = profilePictureUrl
    }
    
    class func fromDictionary(_ dict: [String: Any]) -> UserProfile {
        
        var emailString: String = ""
        var nameString: String = ""
        var surnameString: String = ""
        
        if let email = dict[Keys.Email] as? String {
            emailString = email
        }
        
        if let name = dict[Keys.Name] as? String {
            nameString = name
        }
        
        if let surname = dict[Keys.Surname] as? String {
            surnameString = surname
        }
        
        return UserProfile(id: dict[Keys.Id] as? String, email: emailString, name: nameString,
                           surname: surnameString, displayName: dict[Keys.DisplayName] as? String,
                           profilePictureUrl: dict[Keys.PhotoUrl] as? String)
    }
    
    public func toDictionary() -> [String: String] {
        var dict: [String: String] = [
            Keys.Email: self.email,
            Keys.Name: self.name,
            Keys.Surname: self.surname
        ]
        
        if let identifiedId = self.identifiedId {
            dict.updateValue(identifiedId, forKey: Keys.Id)
        }
        
        if let displayName = self.displayName {
            dict.updateValue(displayName, forKey: Keys.DisplayName)
        }
        
        if let profilePictureUrl = self.profilePictureUrl {
            dict.updateValue(profilePictureUrl, forKey: Keys.PhotoUrl)
        }
        
        return dict
    }
}
