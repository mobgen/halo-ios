//
//  SearchFilterHelper.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 09/06/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

// MARK: Operations

public func eq(property: String, value: AnyObject?) -> SearchFilter {
    return SearchFilter(operation: .Eq, property: property, value: value)
}

public func neq(property: String, value: AnyObject?) -> SearchFilter {
    return SearchFilter(operation: .Neq, property: property, value: value)
}

public func gt(property: String, value: AnyObject?) -> SearchFilter {
    return SearchFilter(operation: .Gt, property: property, value: value)
}

public func lt(property: String, value: AnyObject?) -> SearchFilter {
    return SearchFilter(operation: .Lt, property: property, value: value)
}

public func gte(property: String, value: AnyObject?) -> SearchFilter {
    return SearchFilter(operation: .Gte, property: property, value: value)
}

public func lte(property: String, value: AnyObject?) -> SearchFilter {
    return SearchFilter(operation: .Lte, property: property, value: value)
}

public func valueIn(property: String, value: AnyObject?) -> SearchFilter {
    return SearchFilter(operation: .In, property: property, value: value)
}

public func valueNotIn(property: String, value: AnyObject?) -> SearchFilter {
    return SearchFilter(operation: .NotIn, property: property, value: value)
}

public func or(elements: SearchFilter...) -> SearchFilter {
    
    var filter = SearchFilter()
    
    filter.condition = "or"
    filter.operands = elements
    
    return filter
}

public func and(elements: SearchFilter...) -> SearchFilter {
    
    var filter = SearchFilter()
    
    filter.condition = "and"
    filter.operands = elements
    
    return filter
}

public class SearchFilterHelper {
    
    public static func getDraftItems() -> SearchFilter {
        let condition1 = SearchFilter(operation: .Eq, property: "publishedAt", value: nil)
        let condition2 = SearchFilter(operation: .Eq, property: "archivedAt", value: nil)
        let condition3 = SearchFilter(operation: .Eq, property: "removedAt", value: nil)
        let condition4 = SearchFilter(operation: .Eq, property: "deletedAt", value: nil)
        
        return and(condition1, condition2, condition3, condition4)
    }
    
    public static func getLastUpdatedItems(from: NSDate) -> SearchFilter {
        let condition1 = gte("updatedAt", value: from.timeIntervalSince1970 * 1000)
        let condition2 = lte("updatedAt", value: NSDate().timeIntervalSince1970 * 1000)
        let notDeleted = eq("deletedAt", value: nil)
        
        return and(condition1, condition2, notDeleted)
    }
    
    public static func getArchivedItems() -> SearchFilter {
        let condition1 = lte("archivedAt", value: NSDate().timeIntervalSince1970 * 1000)
        let condition2 = eq("removedAt", value: nil)
        let notDeleted = eq("deletedAt", value: nil)
        
        return and(condition1, condition2, notDeleted)
    }
    
    public static func getExpiredItems() -> SearchFilter {
        let condition1 = lte("removedAt", value: NSDate().timeIntervalSince1970 * 1000)
        let notDeleted = eq("deletedAt", value: nil)
        
        return and(condition1, notDeleted)
    }
    
    public static func getPublishedItems() -> SearchFilter {
        let now = NSDate().timeIntervalSince1970 * 1000
        
        let condition1 = lte("publishedAt", value: now)
        let condition2 = gt("removedAt", value: now)
        let condition3 = eq("removedAt", value: nil)
        let notDeleted = eq("deletedAt", value: nil)
        
        return and(condition1, or(condition2, condition3), notDeleted)
    }
    
}