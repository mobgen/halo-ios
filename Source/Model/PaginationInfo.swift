//
//  PaginationInfo.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloPaginationInfo)
open class PaginationInfo: NSObject, NSCoding {

    struct Keys {
        static let Page = "page"
        static let Limit = "limit"
        static let Offset = "offset"
        static let TotalItems = "totalItems"
        static let TotalPages = "totalPages"
    }

    open internal(set) var page: Int = 0
    open internal(set) var limit: Int = 0
    open internal(set) var offset: Int = 0
    open internal(set) var totalItems: Int = 0
    open internal(set) var totalPages: Int = 0

    fileprivate override init() {
        super.init()
    }

    init(page: Int, limit: Int, offset: Int, totalItems: Int, totalPages: Int) {
        self.page = page
        self.limit = limit
        self.offset = offset
        self.totalItems = totalItems
        self.totalPages = totalPages
        super.init()
    }

    static func fromDictionary(dict: [String: AnyObject]) -> PaginationInfo {

        let info = PaginationInfo()

        info.page = dict[Keys.Page] as? Int ?? 0
        info.limit = dict[Keys.Limit] as? Int ?? 0
        info.offset = dict[Keys.Offset] as? Int ?? 0
        info.totalItems = dict[Keys.TotalItems] as? Int ?? 0
        info.totalPages = dict[Keys.TotalPages] as? Int ?? 0

        return info
    }

    public required init?(coder aDecoder: NSCoder) {
        page = aDecoder.decodeObject(forKey: Keys.Page) as? Int ?? 0
        limit = aDecoder.decodeObject(forKey: Keys.Limit) as? Int ?? 0
        offset = aDecoder.decodeObject(forKey: Keys.Offset) as? Int ?? 0
        totalItems = aDecoder.decodeObject(forKey: Keys.TotalItems) as? Int ?? 0
        totalPages = aDecoder.decodeObject(forKey: Keys.TotalPages) as? Int ?? 0
        super.init()
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(page, forKey: Keys.Page)
        aCoder.encode(limit, forKey: Keys.Limit)
        aCoder.encode(offset, forKey: Keys.Offset)
        aCoder.encode(totalItems, forKey: Keys.TotalItems)
        aCoder.encode(totalPages, forKey: Keys.TotalPages)
    }

}
