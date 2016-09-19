//
//  HaloModuleType.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc public enum ModuleTypeCategory: Int {
    case OffersModule = 3
    case PushNotifications = 2
    case GeneralContentModule = 1
}

/**
Model class representing an existing module type within Halo
*/
@objc(HaloModuleType)
public class ModuleType: NSObject, NSCoding {

    struct Keys {
        static let Category = "category"
        static let Id = "id"
        static let Enabled = "enabled"
        static let Name = "name"
        static let Url = "url"
    }

    /// Unique identifier of the module type
    public internal(set) var category: ModuleTypeCategory?

    /// Flag determining whether the module type is enabled or not
    public internal(set) var enabled: Bool = false

    /// Visual name of the module type
    public internal(set) var name: String?

    /// Url of the module type
    public internal(set) var url: String?

    private override init() {
        super.init()
    }

    /**
    Initialise the module type from a dictionary

    - parameter dict: Dictionary containing all the data about the module type
    */
    static func fromDictionary(dict: [String: AnyObject]) -> ModuleType {

        let type = ModuleType()

        type.category = ModuleTypeCategory(rawValue: dict[Keys.Id] as! Int)
        type.enabled = dict[Keys.Enabled] as? Bool ?? false
        type.name = dict[Keys.Name] as? String
        type.url = dict[Keys.Url] as? String

        return type
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        category = ModuleTypeCategory(rawValue: aDecoder.decodeObjectForKey(Keys.Category) as! Int)
        enabled = aDecoder.decodeObjectForKey(Keys.Enabled) as! Bool
        name = aDecoder.decodeObjectForKey(Keys.Name) as? String
        url = aDecoder.decodeObjectForKey(Keys.Url) as? String
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(category?.rawValue, forKey: Keys.Category)
        aCoder.encodeObject(enabled, forKey: Keys.Enabled)
        aCoder.encodeObject(name, forKey: Keys.Name)
        aCoder.encodeObject(url, forKey: Keys.Url)
    }

}
