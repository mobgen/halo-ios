//
//  BatchOperations.swift
//  Halo
//
//  Created by Santos-Díez, Borja on 25/04/2017.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

@objc(HaloBatchOperations)
public class BatchOperations: NSObject {
    
    public private(set) var create: [ContentInstance] = []
    public private(set) var update: [ContentInstance] = []
    public private(set) var createOrUpdate: [ContentInstance] = []
    public private(set) var delete: [String] = []
    public private(set) var truncate: [String] = []
    
    struct Keys {
        static let Create = "created"
        static let Update = "updated"
        static let CreateOrUpdate = "createdOrUpdated"
        static let Delete = "deleted"
        static let Truncate = "truncated"
    }
    
    internal var body: [String: Any] {
        
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
    
    open func create(_ instances: [ContentInstance]) {
        create.append(contentsOf: instances)
    }
    
    open func update(_ instances: [ContentInstance]) {
        update.append(contentsOf: instances)
    }
    
    open func createOrUpdate(_ instances: [ContentInstance]) {
        createOrUpdate.append(contentsOf: instances)
    }
    
    open func delete(instanceIds: [String]) {
        delete.append(contentsOf: instanceIds)
    }
    
    open func truncate(moduleIds: [String]) {
        truncate.append(contentsOf: moduleIds)
    }
    
    
}
