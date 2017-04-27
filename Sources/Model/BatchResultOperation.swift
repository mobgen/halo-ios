//
//  BatchResultOperation.swift
//  Halo
//
//  Created by Santos-Díez, Borja on 27/04/2017.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

@objc(HaloBatchResultOperation)
public class BatchResultOperation: NSObject {
    
    public internal(set) var operation: BatchOperationType = .create
    public internal(set) var position: Int = 0
    public internal(set) var success: Bool = false
    public internal(set) var contentInstance: ContentInstance?
    public internal(set) var moduleId: String?
    public internal(set) var moduleIds: [String]?
    public internal(set) var error: HaloError?

    struct Keys {
        static let Operation = "operation"
        static let Position = "position"
        static let Success = "success"
        static let Module = "module"
        static let Data = "data"
        
        static let Error = "error"
        
        struct ErrorKeys {
            static let Status = "status"
            static let Message = "message"
            static let Extra = "extra"
        }
    }
    
    class func fromDictionary(_ dict: [String: Any?]) -> BatchResultOperation {

        let result = BatchResultOperation()
        
        result.operation = BatchOperationType(string: dict[Keys.Operation] as? String)
        result.position = dict[Keys.Position] as? Int ?? 0
        result.success = dict[Keys.Success] as? Bool ?? false
        
        if result.success {
            
            switch result.operation {
            case .create: processCreate(result, dict: dict)
            case .update: processUpdate(result, dict: dict)
            case .createOrUpdate: processCreateOrUpdate(result, dict: dict)
            case .delete: processDelete(result, dict: dict)
            case .truncate: processTruncate(result, dict: dict)
            }
        } else {
            // Process error
            if let error = dict[keyPath: "\(Keys.Data).\(Keys.Error)"] as? [String: Any?] {
                processError(result, dict: error)
            }
        }
        
        return result
    }
    
    fileprivate class func processCreate(_ result: BatchResultOperation, dict: [String: Any?]) {
        
        
        
    }
    
    fileprivate class func processUpdate(_ result: BatchResultOperation, dict: [String: Any?]) {
        
    }
    
    fileprivate class func processCreateOrUpdate(_ result: BatchResultOperation, dict: [String: Any?]) {
        
    }
    
    fileprivate class func processDelete(_ result: BatchResultOperation, dict: [String: Any?]) {
        
    }
    
    fileprivate class func processTruncate(_ result: BatchResultOperation, dict: [String: Any?]) {
        
        result.moduleId = dict[Keys.Module] as? String
        
        if let data = dict[Keys.Data] as? [[String: String]] {
            result.moduleIds = data.map { $0["id"]! }
        }
        
    }
    
    fileprivate class func processError(_ result: BatchResultOperation, dict: [String: Any?]) {
        
        
        
    }
    
    
}
