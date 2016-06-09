//
//  SearchFilterHelper.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 09/06/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public class SearchFilterHelper {
    
    public static func getDraftItems() -> SearchFilter {
        let condition1 = SearchFilter(operation: .Eq, property: "publishedAt", value: nil)
        let condition2 = SearchFilter(operation: .Eq, property: "archivedAt", value: nil)
        let condition3 = SearchFilter(operation: .Eq, property: "removedAt", value: nil)
        let condition4 = SearchFilter(operation: .Eq, property: "deletedAt", value: nil)
        
        return and(condition1, condition2, condition3, condition4)
    }
    
    public static func getLastUpdatedItems(from: NSDate) -> SearchFilter {
        let condition1 = SearchFilter(operation: .Gte, property: "updatedAt", date: from.timeIntervalSince1970 * 1000)
        let condition2 = SearchFilter(operation: .Lte, property: "updatedAt", date: NSDate().timeIntervalSince1970 * 1000)
        let notDeleted = SearchFilter(operation: .Eq, property: "deletedAt", value: nil)
        
        return and(condition1, condition2, notDeleted)
    }
    
    public static func getArchivedItems() -> SearchFilter {
        let condition1 = SearchFilter(operation: .Lte, property: "archivedAt", date: NSDate().timeIntervalSince1970 * 1000)
        let condition2 = SearchFilter(operation: .Eq, property: "removedAt", value: nil)
        let notDeleted = SearchFilter(operation: .Eq, property: "deletedAt", value: nil)
        
        return and(condition1, condition2, notDeleted)
    }
    
    public static func getExpiredItems() -> SearchFilter {
        let condition1 = SearchFilter(operation: .Lte, property: "removedAt", date: NSDate().timeIntervalSince1970 * 1000)
        let notDeleted = SearchFilter(operation: .Eq, property: "deletedAt", value: nil)
        
        return and(condition1, notDeleted)
    }
    
    public static func getPublishedItems() -> SearchFilter {
        let now = NSDate().timeIntervalSince1970 * 1000
        
        let condition1 = SearchFilter(operation: .Lte, property: "publishedAt", date: now)
        let condition2 = SearchFilter(operation: .Gt, property: "removedAt", date: now)
        let condition3 = SearchFilter(operation: .Eq, property: "removedAt", value: nil)
        let notDeleted = SearchFilter(operation: .Eq, property: "deletedAt", value: nil)
        
        return and(condition1, or(condition2, condition3), notDeleted)
    }
    
}