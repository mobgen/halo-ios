//
//  SearchFilter.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 07/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

public enum SearchFilterOperation {
    case Eq, Neq, Gt, Lt, Gte, Lte, In, NotIn
    
    public var description: String {
        switch  self {
        case .Eq: return "="
        case .Neq: return "!="
        case .Gt: return ">"
        case .Lt: return "<"
        case .Gte: return ">="
        case .Lte: return "<="
        case .In: return "in"
        case .NotIn: return "!in"
        }
    }
}

public struct SearchFilter {
    
    private var condition: String?
    private var operands: [SearchFilter]?
    
    private var operation: String?
    private var property: String?
    private var value: AnyObject?
    private var type: String?

    public var body: [String: AnyObject] {
        var dict = [String: AnyObject]()
        
        if let
            cond = self.condition,
            operands = self.operands {
                dict["condition"] = cond
                dict["operands"] = operands.map { $0.body }
        }

        if let
            operation = self.operation,
            property = self.property,
            value = self.value,
            type = self.type {
                dict["operation"] = operation
                dict["property"] = property
                dict["value"] = value
                dict["type"] = type
        }
        
        return dict
    }
    
    init() {}
    
    private init(operation: SearchFilterOperation, property: String, value: AnyObject?, type: String?) {
        self.operation = operation.description
        self.property = property
        self.value = value
        
        if let _ = value {
            self.type = type
        } else {
            self.type = "null"
        }
    }
    
    public init(operation: SearchFilterOperation, property: String, number: NSNumber) {
        self.init(operation: operation, property: property, value: number, type: "number")
    }
    
    public init(operation: SearchFilterOperation, property: String, date: Double) {
        self.init(operation: operation, property: property, value: date, type: "date")
    }
    
    public init(operation: SearchFilterOperation, property: String, string: String) {
        self.init(operation: operation, property: property, value: string, type: "string")
    }
    
    public init(operation: SearchFilterOperation, property: String, value: AnyObject?) {
        self.init(operation: operation, property: property, value: value, type: nil)
    }
}

public func or(left lhs: SearchFilter, right rhs: SearchFilter) -> SearchFilter {
    
    var filter = SearchFilter()
    
    filter.condition = "or"
    filter.operands = [lhs, rhs]
    
    return filter
}

public func and(left lhs: SearchFilter, right rhs: SearchFilter) -> SearchFilter {
    
    var filter = SearchFilter()
    
    filter.condition = "and"
    filter.operands = [lhs, rhs]
    
    return filter
}
