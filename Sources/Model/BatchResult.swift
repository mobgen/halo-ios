//
//  BatchResult.swift
//  Halo
//
//  Created by Santos-Díez, Borja on 25/04/2017.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

@objc(HaloBatchResult)
open class BatchResult: NSObject {
    
    struct Keys {
        static let Operations = "operations"
    }
    
    public var operations: [BatchResultOperation] = []
    
    /// Create a BatchResult from a dictionary
    ///
    /// - Parameter dict: Dictionary providing the content of the instance to be created
    /// - Returns: The newly created BatchResult instance
    class func fromDictionary(_ dict: [String: Any?]) -> BatchResult {
        
        let result = BatchResult()
        
        if let operations = dict[Keys.Operations] as? [[String: Any?]] {
            result.operations = operations.map { BatchResultOperation.fromDictionary($0) }
        }
        
        return result
    }
    
}
