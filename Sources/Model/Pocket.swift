//
//  Pocket.swift
//  Halo
//
//  Created by Santos-Díez, Borja on 16/08/2017.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

@objc(HaloPocket)
public class Pocket: NSObject {
    
    struct Keys {
        static let References = "references"
        static let Data = "data"
    }
    
    private(set) public var references: [String: [String]?] = [:]
    public var data: [String: Any] = [:]
    
    @objc(addReferenceWithKey:value:)
    public func addReference(key: String, value: String) -> Void {
        
        if references[key] == nil {
            references[key] = []
        }
        
        // Do not append duplicated values
        if let list = references[key], let referencesList = list {
            if referencesList.firstIndex(of: value) == nil {
                references[key]??.append(value)
            }
        }
        
    }
    
    @objc(removeReferenceWithKey:value:)
    public func removeReference(key: String, value: String) -> Bool {
        
        guard let list = references[key] else {
            return false
        }
        
        if let list = list, let index = list.firstIndex(of: value) {
            references[key]??.remove(at: index)
            return true
        }
        
        return false
    }
    
    @objc(setReferencesWithKey:values:)
    public func setReferences(key: String, values: [String]?) -> Void {
        references[key] = values
    }
    
    @objc(removeReferencesForKey:)
    public func removeReferences(key: String) -> Void {
        self.setReferences(key: key, values: nil)
    }
    
    func toDictionary() -> [String: Any] {
        return [
            Keys.References: references,
            Keys.Data: data
        ]
    }
    
    class func fromDictionary(_ dict: [String: Any?]) -> Pocket {
        
        let pocket = Pocket()
        pocket.references = dict[Keys.References] as? [String: [String]?] ?? [:]
        pocket.data = dict[Keys.Data] as? [String: Any] ?? [:]
        
        return pocket
    }
}
