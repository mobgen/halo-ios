//
//  HaloPaginatedResult.swift
//  HaloSDK
//
//  Created by Borja on 09/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc
public class HaloPaginationInfo: NSObject {

    public var page: Int = 0
    public var limit: Int = 0
    public var count: Int = 0


    init(page: Int?, limit: Int?, count: Int?) {
        super.init()
        self.page = page ?? 0
        self.limit = limit ?? 0
        self.count = count ?? 0
    }

    convenience init(result: PaginatedResult<NSObject>) {
        self.init(page: result.page, limit: result.limit, count: result.count)
    }

}