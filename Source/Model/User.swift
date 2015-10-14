//
//  User.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 21/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloUser)
public final class User: NSObject, NSCoding {

    internal(set) public var id:String?
    internal(set) public var appId:Int?
    public var email:String?
    public var alias:String?
    public var devices:[Halo.UserDevice]?
    public var tags:[String: Halo.UserTag]?
    internal(set) public var createdAt:NSDate?
    internal(set) public var updatedAt:NSDate?

    public override var description: String {
        return "User\n----\n\tid: \(id)\n\temail: \(email)\n\talias:\(alias)\n----"
    }

    public override init() {
        super.init()
    }

    // MARK: NSCoding protocol implementation

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObjectForKey("id") as? String
        self.appId = aDecoder.decodeObjectForKey("appId") as? Int
        self.email = aDecoder.decodeObjectForKey("email") as? String
        self.alias = aDecoder.decodeObjectForKey("alias") as? String
        self.devices = aDecoder.decodeObjectForKey("devices") as? [Halo.UserDevice]
        self.tags = aDecoder.decodeObjectForKey("tags") as? [String: Halo.UserTag]
        self.createdAt = aDecoder.decodeObjectForKey("createdAt") as? NSDate
        self.updatedAt = aDecoder.decodeObjectForKey("updatedAt") as? NSDate
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(appId, forKey: "appId")
        aCoder.encodeObject(email, forKey: "email")
        aCoder.encodeObject(alias, forKey: "alias")
        aCoder.encodeObject(devices, forKey: "devices")
        aCoder.encodeObject(tags, forKey: "tags")
        aCoder.encodeObject(createdAt, forKey: "createdAt")
        aCoder.encodeObject(updatedAt, forKey: "updatedAt")
    }

    // MARK: User tags management

    /**
    Add a custom tag to the user

    - parameter name:  Name of the tag to be added
    - parameter value: Value of the tag to be added
    */
    public func addTag(name: String, value: AnyObject?) {

        if let tags = self.tags {
            if let tag = tags[name] {
                tag.value = value
            } else {
                self.tags![name] = Halo.UserTag(name: name, value: value)
            }
        } else {
            self.tags = [name : Halo.UserTag(name: name, value: value)]
        }

    }

    /**
    Add a collection of custom tags to the user

    - parameter tags: collection of tags
    */
    public func addTags(tags: [String: AnyObject?]) {
        let _ = tags.map({ self.addTag($0, value: $1)})
    }

    // MARK: Management of user storage

    /**
    Store a serialized version of the current user inside the user preferences
    */
    func storeUser(env: HaloEnvironment) -> Void {
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(self)
        let userDefaults = NSUserDefaults.standardUserDefaults()

        userDefaults.setObject(encodedObject, forKey: "\(CoreConstants.userDefaultsUserKey)-\(env.rawValue)")
        userDefaults.synchronize()
    }

    /// Retrieve and deserialize a stored user from the user preferences
    class func loadUser(env: HaloEnvironment) -> Halo.User? {
        
        if let encodedObject = NSUserDefaults.standardUserDefaults().objectForKey("\(CoreConstants.userDefaultsUserKey)-\(env.rawValue)") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject) as? Halo.User
        } else {
            return nil
        }
    }

    /**
    Return a dictionary representation of the user

    - returns: Key-value dictionary containing the user details
    */
    func toDictionary() -> [String: AnyObject] {

        var dict = [String: AnyObject]()

        dict["id"] = self.id
        dict["appId"] = self.appId

        if let email = self.email {
            dict["email"] = email
        }

        if let alias = self.alias {
            dict["alias"] = alias
        }

        if let devices = self.devices {
            dict["devices"] = devices.map({ (device: UserDevice) -> NSDictionary in
                return device.toDictionary()
            })
        }

        if let tags = self.tags {
            dict["tags"] = tags.map({ (key, tag: UserTag) -> NSDictionary in
                tag.toDictionary()
            })
        }

        dict["createdAt"] = ((self.createdAt?.timeIntervalSince1970) ?? 0) * 1000
        dict["updatedAt"] = ((self.updatedAt?.timeIntervalSince1970) ?? 0) * 1000

        return dict

    }

    /**
    Create a user object from a given key-value representation

    - parameter dict: Dictionary containing the key-value representation of the user

    - returns: The newly created user instance
    */
    class func fromDictionary(dict: [String: AnyObject]) -> Halo.User {

        var user: Halo.User

        user = User()

        if let id = dict["id"] as? String {
            user.id = id
        }

        if let appId = dict["appId"] as? Int {
            user.appId = appId
        }

        if let alias = dict["alias"] as? String {
            user.alias = alias
        }

        user.email = dict["email"] as? String
        user.devices = (dict["devices"] as? [[String: AnyObject]])?.map({ (dict: [String: AnyObject]) -> Halo.UserDevice in
            return UserDevice.fromDictionary(dict)
        })

        if let tags = (dict["tags"] as? [[String: AnyObject]])?.map({ (dict: [String: AnyObject]) -> Halo.UserTag in
            return UserTag.fromDictionary(dict)
        }) {
            user.tags = tags.reduce([:], combine: { (var dict, tag: UserTag) -> [String: UserTag] in
                dict[tag.name] = tag
                return dict
            })
        }

        user.createdAt = NSDate(timeIntervalSince1970: (dict["createdAt"] as! NSTimeInterval)/1000)
        user.updatedAt = NSDate(timeIntervalSince1970: (dict["updatedAt"] as! NSTimeInterval)/1000)

        return user
    }

}