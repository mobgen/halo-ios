//
//  SearchOptions.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public struct SearchOptions {
    
    var conditions: String?
    
    public mutating func conditions(conditions: String) -> Halo.SearchOptions {
        self.conditions = conditions
        
        
        
        return self
    }
    
}