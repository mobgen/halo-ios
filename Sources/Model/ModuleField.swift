//
//  ModuleField.swift
//  Halo
//
//  Created by Borja Santos-Díez on 15/02/17.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

class ModuleField {
    
    struct Keys {
        static let Id = "id"
        static let FieldType = "fieldType"
        static let Module = "module"
        static let Name = "name"
        static let Description = "description"
    }
    
    var id: String?
    var fieldType: ModuleFieldType?
    var module: String?
    var name: String?
    var description: String?
    
    var debugDescription: String {
        return [
            "\tFIELD NAME : \(name)",
            "\tDESCRIPTION: \(description)",
            "\tFIELD TYPE : \(fieldType?.name ?? "-")",
            "\tRULES      : \(fieldType?.rules.map { $0.debugDescription }.joined(separator: ", "))"
        ].joined(separator: "\n")
    }
    
    class func fromDictionary(_ dict: [String: Any?]) -> ModuleField {
        
        let field = ModuleField()
        
        field.id = dict[Keys.Id] as? String
        
        if let type = dict[Keys.FieldType] as? [String: Any?] {
            field.fieldType = ModuleFieldType.fromDictionary(type)
        }
        
        field.module = dict[Keys.Module] as? String
        field.name = dict[Keys.Name] as? String
        field.description = dict[Keys.Description] as? String
        
        return field
    }
    
}
