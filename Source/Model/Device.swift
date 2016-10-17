//
//  User.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 21/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/**
Model representing a user within the Halo environment
 */
@objc(HaloDevice)
public final class Device: NSObject, NSCoding {

    struct Keys {
        static let Id = "id"
        static let AppId = "appId"
        static let Email = "email"
        static let Alias = "alias"
        static let Devices = "devices"
        static let Tags = "tags"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
    }

    /// Unique identifier of the user
    public internal(set) var id: String?

    /// Application id which this user is associated to
    public internal(set) var appId: Int?

    /// Email of this user
    public var email: String?

    /// An alias that also identifies the user
    public var alias: String?

    /// List of devices linked to this user
    public var info: Halo.DeviceInfo?

    /// Dictionary of tags associated to this user
    public var tags: [String : Halo.Tag]?

    /// Date of creation of this user
    public internal(set) var createdAt: NSDate?

    /// Date of the last update
    public internal(set) var updatedAt: NSDate?

    public override var description: String {
        return "User\n----\n\tid: \(id)\n\temail: \(email)\n\talias:\(alias)\n\tinfo:\(info)\n----"
    }

    public override init() {
        super.init()
    }

    // MARK: NSCoding protocol implementation

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObjectForKey(Keys.Id) as? String
        self.appId = aDecoder.decodeObjectForKey(Keys.AppId) as? Int
        self.email = aDecoder.decodeObjectForKey(Keys.Email) as? String
        self.alias = aDecoder.decodeObjectForKey(Keys.Alias) as? String
        self.info = aDecoder.decodeObjectForKey(Keys.Devices) as? Halo.DeviceInfo
        self.tags = aDecoder.decodeObjectForKey(Keys.Tags) as? [String: Halo.Tag]
        self.createdAt = aDecoder.decodeObjectForKey(Keys.CreatedAt) as? NSDate
        self.updatedAt = aDecoder.decodeObjectForKey(Keys.UpdatedAt) as? NSDate
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: Keys.Id)
        aCoder.encodeObject(appId, forKey: Keys.AppId)
        aCoder.encodeObject(email, forKey: Keys.Email)
        aCoder.encodeObject(alias, forKey: Keys.Alias)
        aCoder.encodeObject(info, forKey: Keys.Devices)
        aCoder.encodeObject(tags, forKey: Keys.Tags)
        aCoder.encodeObject(createdAt, forKey: Keys.CreatedAt)
        aCoder.encodeObject(updatedAt, forKey: Keys.UpdatedAt)
    }

    // MARK: User tags management

    /**
    Add a custom tag to the user

    - parameter name:  Name of the tag to be added
    - parameter value: Value of the tag to be added
    */
    public func addTag(name name: String, value: String) -> Void {
        self.addTag(name: name, value: value, type: "000000000000000000000002")
    }

    func addSystemTag(name name: String, value: String) -> Void {
        self.addTag(name: name, value: value, type: "000000000000000000000001")
    }

    private func addTag(name name: String, value: String, type: String) -> Void {
        let tag = Halo.Tag(name: name, value: value, type: type)

        if let tags = self.tags {
            if let tag = tags[name] {
                tag.value = value
            } else {
                self.tags![name] = tag
            }
        } else {
            self.tags = [name: tag]
        }
    }

    /**
    Add a collection of custom tags to the user

    - parameter tags: collection of tags
    */
    @objc(addTags:)
    public func addTags(tags tags: [String: String]) {
        tags.forEach { self.addTag(name: $0, value: $1) }
    }

    /**
     Remove a tag by providing its name

     - parameter name: Name of the tag to be removed

     - returns: Returns the removed tag or nil if no tag was found and removed
     */
    public func removeTag(name name: String) -> Halo.Tag? {

        if let _ = self.tags {
            return tags!.removeValueForKey(name)
        } else {
            return nil
        }
    }

    // MARK: Management of user storage

    /**
    Store a serialized version of the current user inside the user preferences
    */
    func storeDevice(env env: HaloEnvironment) -> Void {
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(self)
        let userDefaults = NSUserDefaults.standardUserDefaults()

        userDefaults.setObject(encodedObject, forKey: "\(CoreConstants.userDefaultsDeviceKey)-\(env.description)")
        userDefaults.synchronize()
    }

    /// Retrieve and deserialize a stored user from the user preferences
    class func loadDevice(env env: HaloEnvironment) -> Halo.Device {

        if let encodedObject = NSUserDefaults.standardUserDefaults().objectForKey("\(CoreConstants.userDefaultsDeviceKey)-\(env.description)") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject) as! Halo.Device
        } else {
            return Device()
        }
    }

    /**
    Return a dictionary representation of the user

    - returns: Key-value dictionary containing the user details
    */
    func toDictionary() -> [String: AnyObject] {

        var dict = [String: AnyObject]()

        dict[Keys.Id] = self.id
        dict[Keys.AppId] = self.appId

        if let email = self.email {
            dict[Keys.Email] = email
        }

        if let alias = self.alias {
            dict[Keys.Alias] = alias
        }

        if let info = self.info {
            dict[Keys.Devices] = [info.toDictionary()]
        }

        if let tags = self.tags {
            dict[Keys.Tags] = tags.map({ (key, tag: Halo.Tag) -> NSDictionary in
                tag.toDictionary()
            })
        }

        dict[Keys.CreatedAt] = ((self.createdAt?.timeIntervalSince1970) ?? 0) * 1000
        dict[Keys.UpdatedAt] = ((self.updatedAt?.timeIntervalSince1970) ?? 0) * 1000

        return dict

    }

    /**
    Create a user object from a given key-value representation

    - parameter dict: Dictionary containing the key-value representation of the user

    - returns: The newly created user instance
    */
    @objc(fromDictionary:)
    class func fromDictionary(dict dict: [String: AnyObject]) -> Halo.Device {

        var device: Halo.Device

        device = Device()

        if let id = dict[Keys.Id] as? String {
            device.id = id
        }

        if let appId = dict[Keys.AppId] as? Int {
            device.appId = appId
        }

        if let alias = dict[Keys.Alias] as? String {
            device.alias = alias
        }

        device.email = dict[Keys.Email] as? String
        
        if let info = dict[Keys.Devices] as? [[String: AnyObject]], let first = info.first {
            device.info = DeviceInfo.fromDictionary(dict: first)
        }
        
        if let tags = (dict[Keys.Tags] as? [[String: AnyObject]])?.map({ (dict: [String: AnyObject]) -> Halo.Tag in
            return Halo.Tag.fromDictionary(dict: dict)
        }) {
            device.tags = tags.reduce([:], combine: { (dict, tag: Halo.Tag) -> [String: Halo.Tag] in
                var varDict = dict
                varDict[tag.name] = tag
                return varDict
            })
        }

        if let created = dict[Keys.CreatedAt] as? NSTimeInterval {
            device.createdAt = NSDate(timeIntervalSince1970:created/1000)
        }

        if let updated = dict[Keys.UpdatedAt] as? NSTimeInterval {
            device.updatedAt = NSDate(timeIntervalSince1970:updated/1000)
        }

        return device
    }

}