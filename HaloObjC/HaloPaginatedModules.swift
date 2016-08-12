//
//  HaloPaginatedModules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
import Halo

public class HaloPaginatedModules: NSObject {
   
    public var paginationInfo: HaloPaginationInfo
    public var modules: [HaloModule]
    
    init(data: Halo.PaginatedModules) {
        self.paginationInfo = HaloPaginationInfo(paginationInfo: data.paginationInfo)
        self.modules = data.modules.map { HaloModule(module: $0) }
    }
}