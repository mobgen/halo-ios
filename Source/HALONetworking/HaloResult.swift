//
//  Result.swift
//  HALOFramework
//
//  Created by Borja Santos-Díez on 01/07/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

public enum HaloResult<SuccessType,ErrorType> {
    
    case Success(Box<SuccessType>)
    case Failure(Box<ErrorType>)
    
    public var value: SuccessType? {
        switch self {
        case .Success(let box): return box.unbox
        case .Failure: return nil
        }
    }
    
    public var error: ErrorType? {
        switch self {
        case .Success: return nil
        case .Failure(let err): return err.unbox
        }
    }
    
    public var isSuccess: Bool {
        switch self {
        case .Success: return true
        case .Failure: return false
        }
    }
    
    /**
    Return a new result after applying a transformation to a successful value.
    Mapping a failure returns a new failure without evaluating the transform
    
    :param: transform
    :returns: result
    */
    public func map<U>(transform: SuccessType -> U) -> HaloResult<U,ErrorType> {
        switch self {
        case .Success(let box):
            return .Success(Box(transform(box.unbox)))
        case .Failure(let err):
            return .Failure(err)
        }
    }
    
    /**
    Return a new result after applying a transformation (that itself
    returns a result) to a successful value.
    Calling with a failure returns a new failure without evaluating the transform
    
    :param: transform
    :returns: result
    */
    public func flatMap<U>(transform:SuccessType -> HaloResult<U,ErrorType>) -> HaloResult<U,ErrorType> {
        switch self {
        case Success(let value): return transform(value.unbox)
        case Failure(let error): return .Failure(error)
        }
    }
}

/// Due to current swift limitations, we have to include this Box in Result.
/// Swift cannot handle an enum with multiple associated data (A, NSError) where one is of unknown size (A)
final public class Box<T> {
    public let unbox: T
    public init(_ value: T) { self.unbox = value }
}