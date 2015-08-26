//
//  UserTag.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 21/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

public final class UserTag: NSObject, NSCoding {

    internal(set) public var id: String?
    public var name: String = ""
    public var value: String?

    init(name: String, value: String?) {
        self.name = name
        self.value = value
    }

    // MARK: NSCoding protocol implementation

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        id = aDecoder.decodeObjectForKey("id") as? String
        name = aDecoder.decodeObjectForKey("name") as! String
        value = aDecoder.decodeObjectForKey("value") as? String
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(value, forKey: "value")
    }

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

    class func fromDictionary(dict: [String: AnyObject]) -> UserTag {
        let tag = UserTag(name: dict["name"] as! String, value: dict["value"] as? String)
        tag.id = dict["id"] as? String

        return tag
    }
}

func == (left: UserTag, right: UserTag) -> Bool {
    return left.name == right.name && left.value == right.value
}