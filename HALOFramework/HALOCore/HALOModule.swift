//
//  File.swift
//  HaloFramework
//
//  Created by Borja Santos-Díez on 22/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc
public class HALOModule {
    
    let uniqueId:Int
    
    init(config: NSDictionary) {
        uniqueId = config.description.hash
    }
    
    public func moduleDescription() -> String {
        return  "id: \(uniqueId), name: \(toString(self))"
    }
    
}