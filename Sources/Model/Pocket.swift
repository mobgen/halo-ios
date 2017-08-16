//
//  Pocket.swift
//  Halo
//
//  Created by Santos-Díez, Borja on 16/08/2017.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

@objc(HaloPocket)
public class Pocket: NSObject {
    
    internal(set) public var references: [String: [String]?] = [:]
    internal(set) public var data: [String: Any?] = [:]
    
    @objc(addReferenceWithKey:value:)
    public func addReference(key: String, value: String) -> Void {
        
        if references[key] == nil {
            references[key] = []
        }
        
        references[key]??.append(value)
    }
    
    @objc(removeReferenceWithKey:value:)
    public func removeReference(key: String, value: String) -> Bool {
        
        guard let list = references[key] else {
            return false
        }
        
        if let list = list, let index = list.index(of: value) {
            references[key]??.remove(at: index)
            return true
        }
        
        return false
    }
    
    @objc(setReferenceWithKey:values:)
    public func setReference(key: String, values: [String]?) {
        references[key] = values
    }
    
    @objc(setData:)
    public func setData(_ data: [String: Any]) -> Void {
        self.data = data
    }
}
