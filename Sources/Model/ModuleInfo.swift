//
//  ModuleInfo.swift
//  Halo
//
//  Created by Borja Santos-Díez on 15/02/17.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

import Foundation

class ModuleInfo {
    
    struct Keys {
        static let Name = "name"
        static let Id = "id"
        static let Fields = "fields"
    }
    
    var moduleName: String = "-"
    var moduleId: String = "-"
    var fields: [ModuleField] = []
    
    var debugDescription: String {
        return ["MODULE NAME: \(moduleName)",
                "MODULE ID  : \(moduleId)",
                "FIELDS     :",
                "\(fields.map { "\($0.debugDescription)" }.joined(separator: "\n\t----------------------\n"))"
            ].joined(separator: "\n")
    }
    
    class func fromDictionary(_ dict: [String: Any?]) -> ModuleInfo {
        
        let info = ModuleInfo()
        
        info.moduleName = dict[Keys.Name] as? String ?? "-"
        info.moduleId = dict[Keys.Id] as? String ?? "-"
        
        if let fields = dict[Keys.Fields] as? [[String: Any?]] {
            info.fields = fields.map { ModuleField.fromDictionary($0) }
        }
        
        return info
    }
    
}
