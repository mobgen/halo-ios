//
//  ModuleFieldTypeRule.swift
//  Halo
//
//  Created by Borja Santos-Díez on 15/02/17.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

class ModuleFieldTypeRule {
    
    struct Keys {
        static let Rule = "rule"
        static let Params = "params"
        static let Error = "error"
    }
    
    var rule: String?
    var params: [String] = []
    var error: String?
    
    var debugDescription: String {
        return rule ?? "-"
    }
    
    class func fromDictionary(_ dict: [String: Any?]) -> ModuleFieldTypeRule {
        
        let fieldRule = ModuleFieldTypeRule()
        
        fieldRule.rule = dict[Keys.Rule] as? String
        fieldRule.params = dict[Keys.Params] as? [String] ?? []
        fieldRule.error = dict[Keys.Error] as? String
        
        return fieldRule
    }
    
}
