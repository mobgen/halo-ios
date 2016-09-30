//
//  PaginatedModules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloPaginatedModules)
public class PaginatedModules: NSObject, NSCoding {

    struct Keys {
        static let PaginationInfo = "paginationInfo"
        static let Modules = "modules"
    }

    public internal(set) var paginationInfo: PaginationInfo
    public internal(set) var modules: [Halo.Module]

    init(paginationInfo: PaginationInfo, modules: [Halo.Module]) {
        self.paginationInfo = paginationInfo
        self.modules = modules
    }

    public required init?(coder aDecoder: NSCoder) {
        paginationInfo = aDecoder.decodeObjectForKey(Keys.PaginationInfo) as! PaginationInfo
        modules = aDecoder.decodeObjectForKey(Keys.Modules) as! [Halo.Module]
        super.init()
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(paginationInfo, forKey: Keys.PaginationInfo)
        aCoder.encodeObject(modules, forKey: Keys.Modules)
    }
}
