//
//  ModuleFieldType.swift
//  Halo
//
//  Created by Borja Santos-Díez on 15/02/17.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

class ModuleFieldType {
    
    struct Keys {
        static let Id = "id"
        static let Name = "name"
        static let Rules = "rules"
        static let IsLongValue = "isLongValue"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let DeletedAt = "deletedAt"
    }
    
    var id: String?
    var name: String?
    var rules: [ModuleFieldTypeRule] = []
    var isLongValue: Bool = false
    var deletedAt: Date?
    var createdAt: Date?
    var updatedAt: Date?
    
    class func fromDictionary(_ dict: [String: Any?]) -> ModuleFieldType {
        
        let fieldType = ModuleFieldType()
        
        fieldType.id = dict[Keys.Id] as? String
        fieldType.name = dict[Keys.Name] as? String
        
        if let rules = dict[Keys.Rules] as? [[String: Any?]] {
            fieldType.rules = rules.map { ModuleFieldTypeRule.fromDictionary($0) }
        }
    
        fieldType.isLongValue = dict[Keys.IsLongValue] as? Bool ?? false
        
        if let deletedAt = dict[Keys.DeletedAt] as? Double {
            fieldType.deletedAt = Date(timeIntervalSince1970: deletedAt/1000)
        }
        
        if let createdAt = dict[Keys.CreatedAt] as? Double {
            fieldType.createdAt = Date(timeIntervalSince1970: createdAt/1000)
        }
        
        if let updatedAt = dict[Keys.UpdatedAt] as? Double {
            fieldType.updatedAt = Date(timeIntervalSince1970: updatedAt/1000)
        }
        
        return fieldType
    }
    
}
