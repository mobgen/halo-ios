//
//  UserTag.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 21/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

public final class UserTag: NSObject, NSCoding {

    /// Id of the user tag instance
    internal(set) public var id: String?

    /// Name of the tag
    public var name: String = ""

    /// Value given to the tag
    public var value: AnyObject?

    public init(name: String, value: AnyObject?) {
        self.name = name
        self.value = value
    }

    // MARK: NSCoding protocol implementation

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        id = aDecoder.decodeObjectForKey("id") as? String
        name = aDecoder.decodeObjectForKey("name") as! String
        value = aDecoder.decodeObjectForKey("value")
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(value, forKey: "value")
    }

    /**
    Return a key-value representation of this object

    - returns: A dictionary containing the representation of the object
    */
    func toDictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()

        if let id = self.id {
            dict["id"] = id
        }

        if let val = self.value {
            dict["value"] = val
        }

        dict["name"] = self.name

        return dict
    }

    /**
    Create a user tag object from a given key-value representation

    - parameter dict: The dictionary containing the key-value representation

    - returns: The newly created user tag
    */
    class func fromDictionary(dict: [String: AnyObject]) -> Halo.UserTag {
        let tag = UserTag(name: dict["name"] as! String, value: dict["value"] as? String)
        tag.id = dict["id"] as? String

        return tag
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        if object.dynamicType != self.dynamicType {
            return false
        } else {
            let other = object as! UserTag
            return other.name == self.name
        }
    }
}
