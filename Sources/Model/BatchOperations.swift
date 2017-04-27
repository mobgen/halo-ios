//
//  BatchOperations.swift
//  Halo
//
//  Created by Santos-Díez, Borja on 25/04/2017.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

@objc(HaloBatchOperations)
public class BatchOperations: NSObject {
    
    private(set) var create: [ContentInstance] = []
    private(set) var update: [ContentInstance] = []
    private(set) var createOrUpdate: [ContentInstance] = []
    private(set) var delete: [String] = []
    private(set) var truncate: [String] = []
    
    struct Keys {
        static let Create = "created"
        static let Update = "updated"
        static let CreateOrUpdate = "createdOrUpdated"
        static let Delete = "deleted"
        static let Truncate = "truncated"
    }
    
    var body: [String: Any] {
        
        var result: [String: Any] = [:]
        
        if create.count > 0 {
            result[Keys.Create] = create.map { $0.toDictionary() }
        }
        
        if update.count > 0 {
            result[Keys.Update] = update.map { $0.toDictionary() }
        }
        
        if createOrUpdate.count > 0 {
            result[Keys.CreateOrUpdate] = createOrUpdate.map { $0.toDictionary() }
        }
        
        if delete.count > 0 {
            result[Keys.Delete] = delete.map { ["id": $0] }
        }
        
        if truncate.count > 0 {
            result[Keys.Truncate] = truncate.map { ["module": $0] }
        }
        
        return result
    }
    
    open func create(_ instances: [ContentInstance]) -> BatchOperations {
        create.append(contentsOf: instances)
        return self
    }
    
    open func update(_ instances: [ContentInstance]) -> BatchOperations {
        update.append(contentsOf: instances)
        return self
    }
    
    open func createOrUpdate(_ instances: [ContentInstance]) -> BatchOperations {
        createOrUpdate.append(contentsOf: instances)
        return self
    }
    
    open func delete(instanceIds: [String]) -> BatchOperations {
        delete.append(contentsOf: instanceIds)
        return self
    }
    
    open func truncate(moduleIds: [String]) -> BatchOperations {
        truncate.append(contentsOf: moduleIds)
        return self
    }
    
    
}
