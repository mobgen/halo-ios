//
//  HaloModuleType.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

public class HaloModuleType: NSObject {

    public var typeId: NSNumber?
    public var enabled: Bool = false
    public var name: String?
    public var typeUrl: String?

    init(dict: Dictionary<String, AnyObject>) {
        super.init()
        typeId = dict["id"] as? NSNumber
        enabled = dict["enabled"] as? Bool ?? false
        name = dict["name"] as? String
        typeUrl = dict["url"] as? String
    }

}