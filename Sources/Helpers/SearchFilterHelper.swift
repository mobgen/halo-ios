//
//  SearchFilterHelper.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 09/06/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloSearchFilterHelper)
open class SearchFilterHelper: NSObject {

     static func getDraftItems() -> SearchFilter {
        let condition1 = SearchFilter(operation: .eq, property: "publishedAt", value: nil)
        let condition2 = SearchFilter(operation: .eq, property: "archivedAt", value: nil)
        let condition3 = SearchFilter(operation: .eq, property: "removedAt", value: nil)
        let condition4 = SearchFilter(operation: .eq, property: "deletedAt", value: nil)

        return and(condition1, condition2, condition3, condition4)
    }

     static func getLastUpdatedItems(from: Date) -> SearchFilter {
        let condition1 = gte(property: "updatedAt", value: from.timeIntervalSince1970.intValue * 1000, type: "date")
        let condition2 = lte(property: "updatedAt", value: Date().timeIntervalSince1970.intValue * 1000, type: "date")
        let notDeleted = eq(property: "deletedAt", value: nil)

        return and(condition1, condition2, notDeleted)
    }

     static func getArchivedItems() -> SearchFilter {
        let condition1 = lte(property: "archivedAt", value: Date().timeIntervalSince1970.intValue * 1000, type: "date")
        let condition2 = eq(property: "removedAt", value: nil)
        let notDeleted = eq(property: "deletedAt", value: nil)

        return and(condition1, condition2, notDeleted)
    }

     static func getExpiredItems() -> SearchFilter {
        let condition1 = lte(property: "removedAt", value: Date().timeIntervalSince1970.intValue * 1000, type: "date")
        let notDeleted = eq(property: "deletedAt", value: nil)

        return and(condition1, notDeleted)
    }

    @objc public static func getPublishedItems() -> SearchFilter {
        let now = Date().timeIntervalSince1970.intValue * 1000

        let condition1 = lte(property: "publishedAt", value: now, type: "date")
        let condition2 = gt(property: "removedAt", value: now, type: "date")
        let condition3 = eq(property: "removedAt", value: nil)
        let notDeleted = eq(property: "deletedAt", value: nil)

        return and(condition1, or(condition2, condition3), notDeleted)
    }

}
