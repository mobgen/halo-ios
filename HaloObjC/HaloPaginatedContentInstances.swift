//
//  HaloPaginatedContentInstances.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
import Halo

public class HaloPaginatedContentInstances: NSObject {
    
    public var paginationInfo: HaloPaginationInfo
    public var instances: [HaloContentInstance]
 
    init(data: Halo.PaginatedContentInstances) {
        self.paginationInfo = HaloPaginationInfo(paginationInfo: data.paginationInfo)
        self.instances = data.instances.map { HaloContentInstance(instance: $0) }
    }
    
}