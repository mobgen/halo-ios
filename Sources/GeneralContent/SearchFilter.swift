//
//  SearchFilter.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 07/04/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

enum SearchFilterOperation {
    case eq, neq, gt, lt, gte, lte, `in`, notIn, like

    var description: String {
        switch  self {
        case .eq: return "="
        case .neq: return "!="
        case .gt: return ">"
        case .lt: return "<"
        case .gte: return ">="
        case .lte: return "<="
        case .in: return "in"
        case .notIn: return "!in"
        case .like: return "like"
        }
    }
}

@objc(HaloSearchFilter)
open class SearchFilter: NSObject {

    var condition: String?
    var operands: [SearchFilter]?

    var operation: String?
    var property: String?
    var value: Any? {
        didSet {
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
    var type: String?

    open var body: [String: Any] {
        var dict = [String: Any]()

        if let
            cond = self.condition,
            let operands = self.operands {
                dict["condition"] = cond
                dict["operands"] = operands.map { $0.body }
        }

        if let
            operation = self.operation,
            let property = self.property,
            let type = self.type {
                dict["operation"] = operation
                dict["property"] = property
                dict["value"] = value ?? NSNull()
                dict["type"] = type
        }

        return dict
    }

    override init() {
        super.init()
    }

    init(operation: SearchFilterOperation, property: String, value: Any?, type: String? = nil) {
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
