//
//  HaloModule.swift
//  HaloSDK
//
//  Created by Borja on 28/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

public class HaloModule: NSObject {

    public var moduleId: NSNumber?
    public var name: String?
    public var moduleType: HaloModuleType?

    init(dict: Dictionary<String,AnyObject>) {
        moduleId = dict["id"] as? NSNumber
        name = dict["name"] as? String

        let moduleTypeDict = dict["moduleType"] as? Dictionary<String, AnyObject> ?? [String: AnyObject]()

        moduleType = HaloModuleType(dict: moduleTypeDict)
    }
}
