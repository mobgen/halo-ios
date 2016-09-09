//
//  PaginatedContentInstances.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloPaginatedContentInstances)
public class PaginatedContentInstances: NSObject, NSCoding {

    struct Keys {
        static let PaginationInfo = "paginationInfo"
        static let Instances = "instances"
    }

    public internal(set) var paginationInfo: PaginationInfo
    public internal(set) var instances: [Halo.ContentInstance]

    init(paginationInfo: PaginationInfo, instances: [Halo.ContentInstance]) {
        self.paginationInfo = paginationInfo
        self.instances = instances
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        paginationInfo = aDecoder.decodeObjectForKey(Keys.PaginationInfo) as! PaginationInfo
        instances = aDecoder.decodeObjectForKey(Keys.Instances) as! [Halo.ContentInstance]
        super.init()
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(paginationInfo, forKey: Keys.PaginationInfo)
        aCoder.encodeObject(instances, forKey: Keys.Instances)
    }
}
