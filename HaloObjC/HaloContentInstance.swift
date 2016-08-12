//
//  HaloContentInstance.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
import Halo

public class HaloContentInstance: NSObject {
    
    private var instance: Halo.ContentInstance
    
    public var id: String? {
        return self.instance.id
    }
    
    public var moduleId: String? {
        return self.instance.moduleId
    }
    
    public var name: String? {
        return self.instance.name
    }
    
    public var values: [String: AnyObject] {
        return self.instance.values
    }
    
    public var createdBy: String? {
        return self.instance.createdBy
    }
    
    public var createdAt: NSDate? {
        return self.instance.createdAt
    }
    
    public var publishedAt: NSDate? {
        return self.instance.publishedAt
    }
    
    public var removedAt: NSDate? {
        return self.instance.removedAt
    }
    
    public var updatedAt: NSDate? {
        return self.instance.updatedAt
    }
    
    public var tags: [String: Halo.Tag] {
        return self.instance.tags
    }
    
    init(instance: Halo.ContentInstance) {
        self.instance = instance
    }
    
}