//
//  PaginatedModules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

public struct PaginatedModules {

    public internal(set) var paginationInfo: PaginationInfo
    public internal(set) var modules: [Halo.Module]

    init(paginationInfo: PaginationInfo, modules: [Halo.Module]) {
        self.paginationInfo = paginationInfo
        self.modules = modules
    }
}
