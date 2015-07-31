//
//  HaloModule.swift
//  HaloSDK
//
//  Created by Borja on 28/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/// Model class representing the different modules available in Halo
public class HaloModule: NSObject {

    /// Unique identifier of the module
    public var moduleId: NSNumber?

    /// Visual name of the module
    public var name: String?

    /// Type of the module
    public var moduleType: HaloModuleType?

    /// Date of the last update performed in this module
    public var lastUpdate: NSDate?

    init(dict: Dictionary<String,AnyObject>) {
        moduleId = dict["id"] as? NSNumber
        name = dict["name"] as? String

        let moduleTypeDict = dict["moduleType"] as? Dictionary<String, AnyObject> ?? [String: AnyObject]()
        moduleType = HaloModuleType(dict: moduleTypeDict)

        if let updated = dict["updatedAt"] as? NSNumber {
            lastUpdate = NSDate(timeIntervalSince1970: updated.doubleValue/1000)
        }
    }
}
