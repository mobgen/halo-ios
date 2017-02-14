//
//  UserProfile.swift
//  HaloSocial
//
//  Created by Borja Santos-Díez on 17/11/16.
//  Copyright © 2016 Mobgen Technology. All rights reserved.
//

import Foundation

@objc(HaloUserProfile)
public class UserProfile: NSObject, NSCoding {
    
    struct Keys {
        static let Id = "id"
        static let Email = "email"
        static let Name = "name"
        static let Surname = "surname"
        static let DisplayName = "displayName"
        static let PhotoUrl = "photoUrl"
    }
    
    internal (set) public var identifiedId: String?
    internal (set) public var email: String = ""
    internal (set) public var profilePictureUrl: String?
    var _displayName: String?
    internal (set) public var displayName: String? {
        get {
            return _displayName ?? self.name
        }
        set {
            _displayName = newValue
        }
    }
    internal (set) public var name: String = ""
    internal (set) public var surname: String = ""
    
    public override var debugDescription: String {
        return "[UserProfile] Id: \(identifiedId) | Email: \(email) | DisplayName: \(displayName)"
    }
    
    override init() {
        super.init()
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
    
    public required init?(coder aDecoder: NSCoder) {
        email = aDecoder.decodeObject(forKey: Keys.Email) as? String ?? ""
        name = aDecoder.decodeObject(forKey: Keys.Name) as? String ?? ""
        surname = aDecoder.decodeObject(forKey: Keys.Surname) as? String ?? ""
        super.init()
        identifiedId = aDecoder.decodeObject(forKey: Keys.Id) as? String
        displayName = aDecoder.decodeObject(forKey: Keys.DisplayName) as? String
        profilePictureUrl = aDecoder.decodeObject(forKey: Keys.PhotoUrl) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(identifiedId, forKey: Keys.Id)
        aCoder.encode(email, forKey: Keys.Email)
        aCoder.encode(name, forKey: Keys.Name)
        aCoder.encode(surname, forKey: Keys.Surname)
        aCoder.encode(displayName, forKey: Keys.DisplayName)
        aCoder.encode(profilePictureUrl, forKey: Keys.PhotoUrl)
    }
    
    class func fromDictionary(_ dict: [String: Any]) -> UserProfile {
        
        var emailString = String()
        var nameString = String()
        var surnameString = String()
        
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
