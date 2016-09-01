//
//  SearchFilter.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 07/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

enum SearchFilterOperation {
    case Eq, Neq, Gt, Lt, Gte, Lte, In, NotIn

    var description: String {
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

    var condition: String?
    var operands: [SearchFilter]?

    var operation: String?
    var property: String?
    var value: AnyObject?
    var type: String?

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
            type = self.type {
                dict["operation"] = operation
                dict["property"] = property
                dict["value"] = value ?? NSNull()
                dict["type"] = type
        }

        return dict
    }

    init() {}

    init(operation: SearchFilterOperation, property: String, value: AnyObject?, type: String? = nil) {
        self.operation = operation.description
        self.property = property
        self.value = value

        if let valueType = type {
            self.type = valueType
        } else {
            switch value {
            case _ as String:
                self.type = "string"
            case _ as NSNumber:
                self.type = "number"
            case let data as NSArray:
                if let element = data.firstObject {
                    switch element {
                    case _ as String:
                        self.type = "string"
                    case _ as NSNumber:
                        self.type = "number"
                    default:
                        self.type = "null"
                    }
                } else {
                    self.type = "string"
                }
            default:
                self.type = "null"
            }
        }
    }
}
