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
    }
    
    var id: String?
    var fieldType: ModuleFieldType?
    var module: String?
    var name: String?
    
    class func fromDictionary(_ dict: [String: Any?]) -> ModuleField {
        
        let field = ModuleField()
        
        field.id = dict[Keys.Id] as? String
        
        if let type = dict[Keys.FieldType] as? [String: Any?] {
            field.fieldType = ModuleFieldType.fromDictionary(type)
        }
        
        field.module = dict[Keys.Module] as? String
        field.name = dict[Keys.Name] as? String
        
        return field
    }
    
}
