//
//  PaginatedModules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloPaginatedModules)
open class PaginatedModules: NSObject, NSCoding {

    struct Keys {
        static let PaginationInfo = "paginationInfo"
        static let Modules = "modules"
    }

    @objc open internal(set) var paginationInfo: PaginationInfo
    @objc open internal(set) var modules: [Halo.Module]

    init(paginationInfo: PaginationInfo, modules: [Halo.Module]) {
        self.paginationInfo = paginationInfo
        self.modules = modules
    }

    public required init?(coder aDecoder: NSCoder) {
        paginationInfo = aDecoder.decodeObject(forKey: Keys.PaginationInfo) as! PaginationInfo
        modules = aDecoder.decodeObject(forKey: Keys.Modules) as! [Halo.Module]
        super.init()
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(paginationInfo, forKey: Keys.PaginationInfo)
        aCoder.encode(modules, forKey: Keys.Modules)
    }
}
