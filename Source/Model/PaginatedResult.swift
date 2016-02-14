//
//  PaginatedResult.swift
//  HaloSDK
//
//  Created by Borja on 09/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public class PaginatedResult<ObjectType: NSObject> {

    public var page: Int = 0
    public var limit: Int = 0
    public var count: Int = 0
    public var items: [ObjectType] = []

    convenience init(items: [ObjectType]) {
        self.init(items: items, page: nil, limit: nil, count: nil)
    }

    init(items: [ObjectType], page: Int?, limit: Int?, count: Int?) {
        
        self.items = items

        if let p = page {
            self.page = p
        }

        if let l = limit {
            self.limit = l
        } else {
            self.limit = items.count
        }

        if let c = count {
            self.count = c
        } else {
            self.count = items.count
        }

    }

}