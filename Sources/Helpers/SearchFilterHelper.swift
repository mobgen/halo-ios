//
//  SearchFilterHelper.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 09/06/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

// MARK: Operations

public func eq(property: String, value: Any?, type: String? = nil) -> SearchFilter {
    return SearchFilter(operation: .eq, property: property, value: value, type: type)
}

public func neq(property: String, value: Any?, type: String? = nil) -> SearchFilter {
    return SearchFilter(operation: .neq, property: property, value: value, type: type)
}

public func gt(property: String, value: Any?, type: String? = nil) -> SearchFilter {
    return SearchFilter(operation: .gt, property: property, value: value, type: type)
}

public func lt(property: String, value: Any?, type: String? = nil) -> SearchFilter {
    return SearchFilter(operation: .lt, property: property, value: value, type: type)
}

public func gte(property: String, value: Any?, type: String? = nil) -> SearchFilter {
    return SearchFilter(operation: .gte, property: property, value: value, type: type)
}

public func lte(property: String, value: Any?, type: String? = nil) -> SearchFilter {
    return SearchFilter(operation: .lte, property: property, value: value, type: type)
}

public func valueIn(property: String, value: Any?, type: String? = nil) -> SearchFilter {
    return SearchFilter(operation: .in, property: property, value: value, type: type)
}

public func valueNotIn(property: String, value: Any?, type: String? = nil) -> SearchFilter {
    return SearchFilter(operation: .notIn, property: property, value: value, type: type)
}

public func like(property: String, value: String) -> SearchFilter {
    return SearchFilter(operation: .like, property: property, value: value)
}

public func or(_ elements: SearchFilter...) -> SearchFilter {

    let filter = SearchFilter()

    filter.condition = "or"
    filter.operands = elements

    return filter
}

public func and(_ elements: SearchFilter...) -> SearchFilter {

    let filter = SearchFilter()

    filter.condition = "and"
    filter.operands = elements

    return filter
}

@objc(HaloSearchFilterHelper)
open class SearchFilterHelper: NSObject {

    open static func getDraftItems() -> SearchFilter {
        let condition1 = SearchFilter(operation: .eq, property: "publishedAt", value: nil)
        let condition2 = SearchFilter(operation: .eq, property: "archivedAt", value: nil)
        let condition3 = SearchFilter(operation: .eq, property: "removedAt", value: nil)
        let condition4 = SearchFilter(operation: .eq, property: "deletedAt", value: nil)

        return and(condition1, condition2, condition3, condition4)
    }

    open static func getLastUpdatedItems(from: Date) -> SearchFilter {
        let condition1 = gte(property: "updatedAt", value: from.timeIntervalSince1970 * 1000, type: "date")
        let condition2 = lte(property: "updatedAt", value: Date().timeIntervalSince1970 * 1000, type: "date")
        let notDeleted = eq(property: "deletedAt", value: nil)

        return and(condition1, condition2, notDeleted)
    }

    open static func getArchivedItems() -> SearchFilter {
        let condition1 = lte(property: "archivedAt", value: Date().timeIntervalSince1970 * 1000, type: "date")
        let condition2 = eq(property: "removedAt", value: nil)
        let notDeleted = eq(property: "deletedAt", value: nil)

        return and(condition1, condition2, notDeleted)
    }

    open static func getExpiredItems() -> SearchFilter {
        let condition1 = lte(property: "removedAt", value: Date().timeIntervalSince1970 * 1000, type: "date")
        let notDeleted = eq(property: "deletedAt", value: nil)

        return and(condition1, notDeleted)
    }

    open static func getPublishedItems() -> SearchFilter {
        let now = Date().timeIntervalSince1970 * 1000

        let condition1 = lte(property: "publishedAt", value: now, type: "date")
        let condition2 = gt(property: "removedAt", value: now, type: "date")
        let condition3 = eq(property: "removedAt", value: nil)
        let notDeleted = eq(property: "deletedAt", value: nil)

        return and(condition1, or(condition2, condition3), notDeleted)
    }

}
