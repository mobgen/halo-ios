//
//  UserDevice.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 21/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

public class UserDevice: NSObject, NSCoding {

    public var platform:String = ""
    public var token:String = ""

    init(platform: String, token: String) {
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
}