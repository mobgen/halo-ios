//
//  PaginationInfo.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloPaginationInfo)
public class PaginationInfo: NSObject, NSCoding {

    struct Keys {
        static let Page = "page"
        static let Limit = "limit"
        static let Offset = "offset"
        static let TotalItems = "totalItems"
        static let TotalPages = "totalPages"
    }

    public internal(set) var page: Int = 0
    public internal(set) var limit: Int = 0
    public internal(set) var offset: Int = 0
    public internal(set) var totalItems: Int = 0
    public internal(set) var totalPages: Int = 0

    private override init() {
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
        page = aDecoder.decodeObjectForKey(Keys.Page) as? Int ?? 0
        limit = aDecoder.decodeObjectForKey(Keys.Limit) as? Int ?? 0
        offset = aDecoder.decodeObjectForKey(Keys.Offset) as? Int ?? 0
        totalItems = aDecoder.decodeObjectForKey(Keys.TotalItems) as? Int ?? 0
        totalPages = aDecoder.decodeObjectForKey(Keys.TotalPages) as? Int ?? 0
        super.init()
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(page, forKey: Keys.Page)
        aCoder.encodeObject(limit, forKey: Keys.Limit)
        aCoder.encodeObject(offset, forKey: Keys.Offset)
        aCoder.encodeObject(totalItems, forKey: Keys.TotalItems)
        aCoder.encodeObject(totalPages, forKey: Keys.TotalPages)
    }

}
