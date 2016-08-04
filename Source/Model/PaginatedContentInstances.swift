//
//  PaginatedContentInstances.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

public struct PaginatedContentInstances {
    
    public var paginationInfo: PaginationInfo
    public var instances: [Halo.ContentInstance]
    
    init(paginationInfo: PaginationInfo, instances: [Halo.ContentInstance]) {
        self.paginationInfo = paginationInfo
        self.instances = instances
    }
}
