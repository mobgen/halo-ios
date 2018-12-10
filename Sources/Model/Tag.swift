//
//  UserTag.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 21/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/**
Model representing the tags that can be created an associated within the system, both to
users and content.
 */
@objc(HaloTag)
public final class Tag: NSObject, NSCoding {

    struct Keys {
        static let Id = "id"
        static let Name = "name"
        static let Value = "value"
        static let TagType = "type"
    }

    /// Id of the user tag instance
    public internal(set) var id: String?

    /// Name of the tag
    public internal(set) var name: String = ""

    /// Value given to the tag
    public internal(set) var value: String?

    public internal(set) var type: String?

    fileprivate override init() {
        super.init()
    }

    public init(name: String, value: String, type: String? = nil) {
        super.init()
        self.name = name
        self.value = value
        self.type = type ?? "000000000000000000000002"
    }

    // MARK: NSCoding protocol implementation

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        id = aDecoder.decodeObject(forKey: Keys.Id) as? String
        name = aDecoder.decodeObject(forKey: Keys.Name) as! String
        value = aDecoder.decodeObject(forKey: Keys.Value) as? String
        type = aDecoder.decodeObject(forKey: Keys.TagType) as? String
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Keys.Id)
        aCoder.encode(name, forKey: Keys.Name)
        aCoder.encode(value, forKey: Keys.Value)
        aCoder.encode(type, forKey: Keys.TagType)
    }

    /**
    Return a key-value representation of this object

    - returns: A dictionary containing the representation of the object
    */
    public func toDictionary() -> [String: Any] {
        var dict = [String: Any]()

        if let id = self.id {
            dict["id"] = id
        }

        dict["name"] = self.name

        if let val = self.value {
            dict["value"] = val
        }

        if let type = self.type {
            dict["tagType"] = type
        }

        return dict
    }

    /**
    Create a user tag object from a given key-value representation

    - parameter dict: The dictionary containing the key-value representation

    - returns: The newly created user tag
    */
    class func fromDictionary(dict: [String: Any]) -> Halo.Tag {
        let tag = Tag(name: dict["name"] as! String, value: dict["value"] as! String, type: dict["tagType"] as? String)
        tag.id = dict["id"] as? String

        return tag
    }

    public override func isEqual(_ object: Any?) -> Bool {
        if Swift.type(of: object) != Swift.type(of: self) {
            return false
        } else {
            let other = object as! Halo.Tag
            return other.name == self.name
        }
    }
}
