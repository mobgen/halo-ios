//
//  SearchOptions.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public struct SearchOptions {
    
    internal var moduleIds: [String]?
    internal var instanceIds: [String]?
    internal var conditions: [String: AnyObject]?
    internal var metaConditions: [String: AnyObject]?
    internal var fields: [String]?
    internal var populateFields: [String]?
    internal var tags: [Halo.Tag]?
    internal var pagination: [String: AnyObject]?
    internal var user: Halo.User?
    internal var offlinePolicy: Halo.OfflinePolicy?
    internal var generalContentFlags: Halo.GeneralContentFlag?
    
    public var body: [String: AnyObject] {
        var dict = [String: AnyObject]()
        
        if let modules = self.moduleIds {
            dict["moduleIds"] = modules
        }
        
        if let instances = self.instanceIds {
            dict["instanceIds"] = instances
        }
        
        if let searchValues = self.conditions {
            dict["searchValues"] = searchValues
        }
        
        if let metaSearch = self.metaConditions {
            dict["metaSearch"] = metaSearch
        }
        
        if let fields = self.fields {
            dict["fields"] = fields
        }
        
        if let tags = self.tags {
            dict["tags"] = tags.map { $0.toDictionary() }
        }
        
        if let include = self.populateFields {
            dict["include"] = include
        }
        
        if let pagination = self.pagination {
            dict["pagination"] = pagination
        }
        
        if let user = self.user, tags = user.tags {
            if tags.count > 0 {
                dict["segmentTags"] = tags.values.map { $0.toDictionary() }
            }
        }
        
        if let flags = self.generalContentFlags {
            if !flags.contains(GeneralContentFlag.IncludeArchived) {
                dict["archived"] = "false"
            }
        }
        
        return dict
    }
    
    public init() {}
    
    public mutating func addSearchFilter(filter: SearchFilter) -> Halo.SearchOptions {
        self.conditions = filter.body
        return self
    }
    
    public mutating func addMetaFilter(filter: SearchFilter) -> Halo.SearchOptions {
        self.metaConditions = filter.body
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
    
    public mutating func addModuleIds(ids: [String]) -> Halo.SearchOptions {
        self.moduleIds = ids
        return self
    }
    
    public mutating func addInstanceIds(ids: [String]) -> Halo.SearchOptions {
        self.instanceIds = ids
        return self
    }

    public mutating func addPopulateFields(fields: [String]) -> Halo.SearchOptions {
        self.populateFields = fields
        return self
    }
    
    public mutating func populateAll() -> Halo.SearchOptions {
        self.populateFields = ["all"]
        return self
    }
    
    public mutating func setUser(user: Halo.User) -> Halo.SearchOptions {
        self.user = user
        return self
    }
    
    public mutating func skipPagination() -> Halo.SearchOptions {
        self.pagination = ["skip": true]
        return self
    }
    
    public mutating func addPagination(page: Int, limit: Int, skip: Bool) -> Halo.SearchOptions {
        self.pagination = [
            "page"  : page,
            "limit" : limit,
            "skip"  : skip
        ]
        return self
    }
    
    public mutating func setOfflinePolicy(policy: Halo.OfflinePolicy) -> Halo.SearchOptions {
        self.offlinePolicy = policy
        return self
    }
    
    public mutating func setGeneralContentFlags(flags: Halo.GeneralContentFlag) -> Halo.SearchOptions {
        self.generalContentFlags = flags
        return self
    }
}