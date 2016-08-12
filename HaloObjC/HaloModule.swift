//
//  HaloModule.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
import Halo

public class HaloModule: NSObject {
    
    private var module: Halo.Module
    
    public var customerId: Int? {
        return self.module.customerId
    }
    
    public var id: Int? {
        return self.module.id
    }
    
    public var internalId: String? {
        return self.module.internalId
    }
    
    public var name: String? {
        return self.module.name
    }
    
    public var type: HaloModuleType?
    
    public var enabled: Bool {
        return self.module.enabled
    }
    
    public var isSingle: Bool {
        return self.module.isSingle
    }
    
    public var createdAt: NSDate? {
        return self.module.createdAt
    }
    
    public var updatedAt: NSDate? {
        return self.module.updatedAt
    }

    public var tags: [String: Halo.Tag] {
        return self.module.tags
    }
    
    init(module: Halo.Module) {
        self.module = module
        
        if let t = module.type {
            self.type = HaloModuleType(type: t)
        }
    }
    
}