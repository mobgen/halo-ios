//
//  SearchOptions.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public struct SearchOptions {
    
    private var conditions: [String: AnyObject]?
    private var fields: [String]?
    private var tags: [Halo.Tag]?
    
    public var body: [String: AnyObject] {
        var dict = [String: AnyObject]()
        
        if let searchValues = self.conditions {
            dict["searchValues"] = searchValues
        }
        
        if let fields = self.fields {
            dict["fields"] = fields
        }
        
        if let tags = self.tags {
            dict["tags"] = tags.map { $0.toDictionary() }
        }
        
        return dict
    }
    
    public mutating func addConditions(conditions: String) -> Halo.SearchOptions {
        self.conditions = processCondition(infixToPrefix(conditions))
        return self
    }
    
    public mutating func addFields(fields: [String]) -> Halo.SearchOptions {
        self.fields = fields
        return self
    }
    
    public mutating func addTags(tags: [Halo.Tag]) -> Halo.SearchOptions {
        self.tags = tags
        return self
    }
    
}