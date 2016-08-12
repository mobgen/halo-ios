//
//  HaloModuleType.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
import Halo

public class HaloModuleType: NSObject {
    
    private var type: Halo.ModuleType
    
    public var category: ModuleTypeCategory? {
        return self.type.category
    }
    
    public var enabled: Bool {
        return self.type.enabled
    }
    
    public var name: String? {
        return self.type.name
    }
    
    public var typeUrl: String? {
        return self.type.typeUrl
    }
    
    init(type: Halo.ModuleType) {
        self.type = type
    }
    
}