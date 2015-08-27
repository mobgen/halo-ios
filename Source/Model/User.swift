//
//  User.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 21/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

public final class User: NSObject, NSCoding {

    internal(set) public var id:String?
    internal(set) public var appId:Int?
    public var email:String?
    public var alias:String?
    public var devices:[Halo.UserDevice]?
    public var tags:Set<Halo.UserTag>?
    internal(set) public var createdAt:NSDate?
    internal(set) public var updatedAt:NSDate?

    public override var description: String {
        return "User\n----\n\tid: \(id)\n\temail: \(email)\n\talias:\(alias)\n----"
    }

    // MARK: NSCoding protocol implementation

    public override init() {
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObjectForKey("id") as? String
        self.appId = aDecoder.decodeObjectForKey("appId") as? Int
        self.email = aDecoder.decodeObjectForKey("email") as? String
        self.alias = aDecoder.decodeObjectForKey("alias") as? String
        self.devices = aDecoder.decodeObjectForKey("devices") as? [Halo.UserDevice]
        self.tags = aDecoder.decodeObjectForKey("tags") as? Set<Halo.UserTag>
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

    public func addTag(name: String, value: String?) {

        let tag = Halo.UserTag(name: name, value: value)

        if let tags = self.tags {
            if tags.contains(tag) {
                return
            }
        } else {
            self.tags = []
        }

        self.tags?.insert(tag)
    }

    public func addTags(tags: Dictionary<String, String?>) {
        for (name, value) in tags {
            self.addTag(name, value: value)
        }
    }

    // MARK: Management of user storage

    func storeUser() -> Void {
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(self)
        let userDefaults = NSUserDefaults.standardUserDefaults()

        userDefaults.setObject(encodedObject, forKey: CoreConstants.userDefaultsUserKey)
        userDefaults.synchronize()
    }

    class func loadUser() -> Halo.User? {
        if let encodedObject = NSUserDefaults.standardUserDefaults().objectForKey(CoreConstants.userDefaultsUserKey) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject) as? Halo.User
        } else {
            return nil
        }
    }

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

        dict["devices"] = self.devices?.map({ (device: UserDevice) -> NSDictionary in
            return device.toDictionary()
        })
        dict["tags"] = self.tags?.map({ (tag: UserTag) -> NSDictionary in
            return tag.toDictionary()
        })
        dict["createdAt"] = ((self.createdAt?.timeIntervalSince1970) ?? 0) * 1000
        dict["updatedAt"] = ((self.updatedAt?.timeIntervalSince1970) ?? 0) * 1000

        return dict

    }

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
            user.tags = Set(tags)
        }

        user.createdAt = NSDate(timeIntervalSince1970: (dict["createdAt"] as! NSTimeInterval)/1000)
        user.updatedAt = NSDate(timeIntervalSince1970: (dict["updatedAt"] as! NSTimeInterval)/1000)

        return user

    }

}