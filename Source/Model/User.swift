//
//  User.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 21/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

public class User: NSObject, NSCoding {

    internal(set) public var id:Int = 0
    internal(set) public var appId:Int = 0
    public var email:String?
    public var alias:String = ""
    public var devices:[Halo.UserDevice]?
    public var tags:[Halo.UserTag]?
    internal(set) public var createdAt:NSDate?
    internal(set) public var updatedAt:NSDate?

    public override var description: String {
        return "id: \(id)\nemail: \(email)\nalias:\(alias)"
    }

    init(id: Int, appId: Int, alias: String) {
        self.id = id
        self.appId = appId
        self.alias = alias
    }

    // MARK: NSCoding protocol implementation

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeIntegerForKey("id")
        self.appId = aDecoder.decodeIntegerForKey("appId")
        self.email = aDecoder.decodeObjectForKey("email") as? String
        self.alias = aDecoder.decodeObjectForKey("alias") as! String
        self.devices = aDecoder.decodeObjectForKey("devices") as? [Halo.UserDevice]
        self.tags = aDecoder.decodeObjectForKey("tags") as? [Halo.UserTag]
        self.createdAt = aDecoder.decodeObjectForKey("createdAt") as? NSDate
        self.updatedAt = aDecoder.decodeObjectForKey("updatedAt") as? NSDate
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(id, forKey: "id")
        aCoder.encodeInteger(appId, forKey: "appId")
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

        self.tags?.append(tag)
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



}