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
        static let CredentialsHash = "credentialsHash"
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
    public internal(set) var createdAt: Date?

    /// Date of the last update
    public internal(set) var updatedAt: Date?

    var credentialsHash: Int?
    
    public override var description: String {
        return "Device\n----\n\tid: \(id ?? "-")\n\temail: \(email)\n\talias:\(alias)\n\tinfo:\(info)\n----"
    }

    public override init() {
        super.init()
    }

    // MARK: NSCoding protocol implementation

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObject(forKey: Keys.Id) as? String
        self.appId = aDecoder.decodeObject(forKey: Keys.AppId) as? Int
        self.email = aDecoder.decodeObject(forKey: Keys.Email) as? String
        self.alias = aDecoder.decodeObject(forKey: Keys.Alias) as? String
        self.info = aDecoder.decodeObject(forKey: Keys.Devices) as? Halo.DeviceInfo
        self.tags = aDecoder.decodeObject(forKey: Keys.Tags) as? [String: Halo.Tag]
        self.createdAt = aDecoder.decodeObject(forKey: Keys.CreatedAt) as? Date
        self.updatedAt = aDecoder.decodeObject(forKey: Keys.UpdatedAt) as? Date
        self.credentialsHash = aDecoder.decodeObject(forKey: Keys.CredentialsHash) as? Int
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Keys.Id)
        aCoder.encode(appId, forKey: Keys.AppId)
        aCoder.encode(email, forKey: Keys.Email)
        aCoder.encode(alias, forKey: Keys.Alias)
        aCoder.encode(info, forKey: Keys.Devices)
        aCoder.encode(tags, forKey: Keys.Tags)
        aCoder.encode(createdAt, forKey: Keys.CreatedAt)
        aCoder.encode(updatedAt, forKey: Keys.UpdatedAt)
        aCoder.encode(credentialsHash, forKey: Keys.CredentialsHash)
    }

    // MARK: User tags management

    /**
    Add a custom tag to the user

    - parameter name:  Name of the tag to be added
    - parameter value: Value of the tag to be added
    */
    public func addTag(name: String, value: String) -> Void {
        self.addTag(name: name, value: value, type: "000000000000000000000002")
    }

    func addSystemTag(name: String, value: String) -> Void {
        self.addTag(name: name, value: value, type: "000000000000000000000001")
    }

    fileprivate func addTag(name: String, value: String, type: String) -> Void {
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
    public func addTags(tags: [String: String]) {
        tags.forEach { self.addTag(name: $0, value: $1) }
    }

    /**
     Remove a tag by providing its name

     - parameter name: Name of the tag to be removed

     - returns: Returns the removed tag or nil if no tag was found and removed
     */
    public func removeTag(name: String) -> Halo.Tag? {
        if let _ = self.tags {
            return tags!.removeValue(forKey: name)
        }
        
        return nil
    }

    // MARK: Storing and loading device

    /**
    Store a serialized version of the current device inside the keychain
    */
    func storeDevice(env: HaloEnvironment = Manager.core.environment) -> Void {
        
        // Set the current credentials for later comparison...
        self.credentialsHash = Manager.core.appCredentials?.hashValue
        
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: self)
        KeychainHelper.set(encodedObject, forKey: "\(CoreConstants.keychainDeviceKey)-\(env.description)")
    }

    /// Retrieve and deserialize a stored user from the user preferences
    class func loadDevice(env: HaloEnvironment = Manager.core.environment) -> Halo.Device {
        if let encodedObject = KeychainHelper.data(forKey: "\(CoreConstants.keychainDeviceKey)-\(env.description)") {
            
            // Check if credentials match...
            if let device = NSKeyedUnarchiver.unarchiveObject(with: encodedObject) as? Halo.Device,
                let hash = Manager.core.appCredentials?.hashValue,
                let deviceHash = device.credentialsHash {
                    return (hash == deviceHash) ? device : Device()
            }
            
            return Device()
        }
        
        return Device()
    }
    
    class func removeDevice(env: HaloEnvironment = Manager.core.environment) -> Bool {
        return KeychainHelper.remove(forKey: "\(CoreConstants.keychainDeviceKey)-\(env.description)")
    }

    /**
    Return a dictionary representation of the user

    - returns: Key-value dictionary containing the user details
    */
    func toDictionary() -> [String: Any] {

        var dict = [String: Any]()

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
            let tagsList = tags.map { $0.value.toDictionary() } as AnyObject
            dict.updateValue(tagsList, forKey: Keys.Tags)
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
    class func fromDictionary(dict: [String: Any]) -> Halo.Device {

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
        
        if let info = dict[Keys.Devices] as? [[String: Any]], let first = info.first {
            device.info = DeviceInfo.fromDictionary(dict: first)
        }
        
        if let tags = (dict[Keys.Tags] as? [[String: Any]])?.map({ (dict: [String: Any]) -> Halo.Tag in
            return Halo.Tag.fromDictionary(dict: dict)
        }) {
            device.tags = tags.reduce([:], { (dict, tag: Halo.Tag) -> [String: Halo.Tag] in
                var varDict = dict
                varDict[tag.name] = tag
                return varDict
            })
        }

        if let created = dict[Keys.CreatedAt] as? TimeInterval {
            device.createdAt = Date(timeIntervalSince1970:created/1000)
        }

        if let updated = dict[Keys.UpdatedAt] as? TimeInterval {
            device.updatedAt = Date(timeIntervalSince1970:updated/1000)
        }

        return device
    }

}
