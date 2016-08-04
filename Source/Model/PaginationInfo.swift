//
//  PaginationInfo.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public struct PaginationInfo {
    
    public var page: Int
    public var limit: Int
    public var offset: Int
    public var totalItems: Int
    public var totalPages: Int
    
    init(page: Int, limit: Int, offset: Int, totalItems: Int, totalPages: Int) {
        self.page = page
        self.limit = limit
        self.offset = offset
        self.totalItems = totalItems
        self.totalPages = totalPages
    }
    
    init(data: [String: AnyObject]) {
        self.page = data["page"] as? Int ?? 0
        self.limit = data["limit"] as? Int ?? 0
        self.offset = data["offset"] as? Int ?? 0
        self.totalItems = data["totalItems"] as? Int ?? 0
        self.totalPages = data["totalPages"] as? Int ?? 0
    }
    
}