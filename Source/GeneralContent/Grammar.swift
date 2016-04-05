//
//  Grammar.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

enum GrammarToken {
    case ParensOpen
    case ParensClose
    case StringOpen
    case StringClose
    case Number(Float)
    case Identifier(String)
    case Operator(String)
}

public func infixToPrefix(expression: String) -> [String] {
    
    var stack: [String] = []
    var prefix: [String] = []
    
    let tokens = expression
        .stringByReplacingOccurrencesOfString(")", withString: " ) ")
        .stringByReplacingOccurrencesOfString("(", withString: " ( ")
        .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
    let tokensArr = tokens
        .stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch, range: Range(tokens.startIndex ..< tokens.endIndex))
        .componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).reverse()
    
    for token in tokensArr {
        
        if isOperator(token) {
            
            if token == ")" {
                stack.append(token)
            } else if token == "(" {
                while let top = stack.last where top != ")" {
                    prefix.append(stack.popLast()!)
                }
                stack.popLast()
            } else {
                if let top = stack.last where precedence(top) <= precedence(token) {
                    stack.append(token)
                } else {
                    while let top = stack.last where precedence(top) >= precedence(token) {
                        prefix.append(stack.popLast()!)
                    }
                    stack.append(token)
                }
            }
        } else {
            prefix.append(token)
        }
    }
    
    while let top = stack.popLast() {
        prefix.append(top)
    }
    
    return prefix
    
}

public func isOperator(str: String) -> Bool {
    switch str {
    case "=", "!=", ">", ">=", "<", "<=", "OR", "AND", "IN", "NOT_IN", "(", ")":
        return true
    default:
        return false
    }
}

public func precedence(symbol: String) -> Int {
    switch(symbol) {
    case "=", "!=", ">", ">=", "<", "<=", "IN", "NOT_IN":
        return 3
    case "AND", "OR":
        return 2
    case "(", ")":
        return 1
    default:
        return 0
    }
}

public enum TokenType {
    case Condition, Operation, Operand
}

public func tokenType(token: String) -> TokenType {
    switch token {
    case "=", "!=", ">", ">=", "<", "<=", "IN", "NOT_IN":
        return .Operation
    case "AND", "OR":
        return .Condition
    default:
        return .Operand
    }
}

public func processCondition(tokens: [String], dict: [String: AnyObject]) -> [String: AnyObject] {
    
    var tokenArr = tokens
    var currentOperand = dict
    
    if let token = tokenArr.popLast() {
        
        switch tokenType(token) {
        case .Operand:
            if let _ = currentOperand["property"] {
                currentOperand["value"] = token
                currentOperand["type"] = "test"
            } else {
                currentOperand["property"] = token
            }
        case .Operation:
            currentOperand["operation"] = token
        case .Condition:
            currentOperand["condition"] = token
            currentOperand["operands"] = processConditionOperands(tokenArr, dict: [:])
        }
    }
    
    return currentOperand
}

public func processConditionOperands(tokens: [String], dict:[String: AnyObject], operands: [[String: AnyObject]]? = nil) -> [[String: AnyObject]] {
    
    var tokenArr = tokens
    var operandsArr = operands ?? []
    var currentOperand = dict ?? [:]
    
    if let token = tokenArr.popLast() {
        switch tokenType(token) {
        case .Operand:
            if let _ = currentOperand["property"] {
                currentOperand["value"] = token
                currentOperand["type"] = "test"
                operandsArr.append(currentOperand)
                operandsArr = processConditionOperands(tokenArr, dict: [:], operands: operandsArr)
            } else {
                currentOperand["property"] = token
                operandsArr = processConditionOperands(tokenArr, dict: currentOperand, operands: operandsArr)
            }
        case .Operation:
            currentOperand["operation"] = token
            operandsArr = processConditionOperands(tokenArr, dict: currentOperand, operands: operandsArr)
        case .Condition:
            currentOperand["condition"] = token
            currentOperand["operands"] = processConditionOperands(tokenArr, dict: [:])
        }
    }
    
    return operandsArr
}

public func JSONStringify(value: AnyObject, prettyPrinted: Bool = true) -> String {
    
    let options: NSJSONWritingOptions = prettyPrinted ? .PrettyPrinted : []
    
    if NSJSONSerialization.isValidJSONObject(value) {
        let data = try! NSJSONSerialization.dataWithJSONObject(value, options: options)
        if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
            return string as String
        }
    }
    
    return ""
}
