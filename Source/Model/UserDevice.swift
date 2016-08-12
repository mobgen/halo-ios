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
        platform = aDecoder.decodeObjectForKey("platform") as! String
        token = aDecoder.decodeObjectForKey("token") as! String
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(platform, forKey: "platform")
        aCoder.encodeObject(token, forKey: "token")
    }

    /**
    Create a key-value representation of this user device object

    - returns: Dictionary containing the representation of the object
    */
    func toDictionary() -> [String: AnyObject] {
        return [
            "platform"  : self.platform,
            "token"     : self.token
        ]
    }

    /**
    Create a user device object from a given key-value representation

    - parameter dict: A dictionary containing the values to build a user device

    - returns: The newly created user device
    */
    class func fromDictionary(dict: [String: AnyObject]) -> Halo.UserDevice {
        return UserDevice(platform: dict["platform"] as! String, token: dict["token"] as! String)
    }
}
