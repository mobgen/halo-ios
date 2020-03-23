//
//  PaginatedContentInstances.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloPaginatedContentInstances)
open class PaginatedContentInstances: NSObject, NSCoding {

    struct Keys {
        static let PaginationInfo = "paginationInfo"
        static let Instances = "instances"
    }

    @objc open internal(set) var paginationInfo: PaginationInfo
    @objc open internal(set) var instances: [Halo.ContentInstance]

    init(paginationInfo: PaginationInfo, instances: [Halo.ContentInstance]) {
        self.paginationInfo = paginationInfo
        self.instances = instances
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        paginationInfo = aDecoder.decodeObject(forKey: Keys.PaginationInfo) as! PaginationInfo
        instances = aDecoder.decodeObject(forKey: Keys.Instances) as! [Halo.ContentInstance]
        super.init()
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(paginationInfo, forKey: Keys.PaginationInfo)
        aCoder.encode(instances, forKey: Keys.Instances)
    }
}
