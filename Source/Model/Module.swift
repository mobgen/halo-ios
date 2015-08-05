//
//  HaloModule.swift
//  HaloSDK
//
//  Created by Borja on 28/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/// Model class representing the different modules available in Halo
public class Module: NSObject {

    /// Unique identifier of the module
    public var id: NSNumber?

    /// Visual name of the module
    public var name: String?

    /// Type of the module
    public var type: Halo.ModuleType?

    /// Date of the last update performed in this module
    public var lastUpdate: NSDate?

    public var internalId: String?

    /**
    Initialise a HaloModule from a dictionary
    
    - parameter dict:   Dictionary containing the information about the module
    */
    init(_ dict: Dictionary<String,AnyObject>) {
        id = dict["id"] as? NSNumber
        name = dict["name"] as? String

        let moduleTypeDict = dict["moduleType"] as? Dictionary<String, AnyObject> ?? [String: AnyObject]()
        type = ModuleType(moduleTypeDict)

        if let updated = dict["updatedAt"] as? NSNumber {
            lastUpdate = NSDate(timeIntervalSince1970: updated.doubleValue/1000)
        }

        if let intId = dict["internalId"] as? String {
            internalId = intId
        }
    }
}
