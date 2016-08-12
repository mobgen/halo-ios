//
//  HaloPaginationInfo.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
import Halo

public class HaloPaginationInfo: NSObject {
    
    private var paginationInfo: Halo.PaginationInfo
    
    public var page: Int {
        return self.paginationInfo.page
    }
    
    public var limit: Int {
        return self.paginationInfo.limit
    }
    
    public var offset: Int {
        return self.paginationInfo.offset
    }
    
    public var totalItems: Int {
        return self.paginationInfo.totalItems
    }
    
    public var totalPages: Int {
        return self.paginationInfo.totalPages
    }
    
    init(paginationInfo: Halo.PaginationInfo) {
        self.paginationInfo = paginationInfo
    }
    
}