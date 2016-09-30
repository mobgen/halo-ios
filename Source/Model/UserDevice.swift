//
//  UserDevice.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 21/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/**
Representation of a user's device, containing information such as the platform
or the push notifications token.
 */
@objc(HaloUserDevice)
public final class UserDevice: NSObject, NSCoding {

    struct Keys {
        static let Platform = "platform"
        static let Token = "token"
    }

    /// Platform of the device
    public  internal(set) var platform: String = ""

    /// Token used for push notifications
    public  internal(set) var token: String = ""

    public override var description: String {
        return "\n\t\tplatform: \(platform)\n\t\ttoken: \(token)"
    }

    public init(platform: String, token: String) {
        self.platform = platform
        self.token = token
    }

    // MARK: NSCoding protocol implementation

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        platform = aDecoder.decodeObjectForKey(Keys.Platform) as! String
        token = aDecoder.decodeObjectForKey(Keys.Token) as! String
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(platform, forKey: Keys.Platform)
        aCoder.encodeObject(token, forKey: Keys.Token)
    }

    /**
    Create a key-value representation of this user device object

    - returns: Dictionary containing the representation of the object
    */
    func toDictionary() -> [String: AnyObject] {
        return [
            Keys.Platform  : self.platform,
            Keys.Token     : self.token
        ]
    }

    /**
    Create a user device object from a given key-value representation

    - parameter dict: A dictionary containing the values to build a user device

    - returns: The newly created user device
    */
    class func fromDictionary(dict dict: [String: AnyObject]) -> Halo.UserDevice {
        return UserDevice(platform: dict[Keys.Platform] as! String, token: dict[Keys.Token] as! String)
    }
}
