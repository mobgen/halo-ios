//
//  SearchOptions.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc
public enum SegmentMode: Int {
    case Total, Partial

    public var description: String {
        switch self {
        case .Total: return "total"
        case .Partial: return "partial"
        }
    }
}

@objc(HaloSearchQuery)
public class SearchQuery: NSObject {

    struct Keys {
        static let ModuleName = "moduleName"
        static let ModuleIds = "moduleIds"
        static let InstanceIds = "instanceIds"
        static let SearchValues = "searchValues"
        static let MetaSearch = "metaSearch"
        static let Fields = "fields"
        static let Tags = "tags"
        static let Include = "include"
        static let Pagination = "pagination"
        static let SegmentTags = "segmentTags"
        static let SegmentMode = "segmentMode"
        static let Locale = "locale"
    }

    private(set) var moduleName: String?
    private(set) var moduleIds: [String]?
    private(set) var instanceIds: [String]?
    private(set) var conditions: [String: AnyObject]?
    private(set) var metaConditions: [String: AnyObject]?
    private(set) var fields: [String]?
    private(set) var populateFields: [String]?
    private(set) var tags: [Halo.Tag]?
    private(set) var pagination: [String: AnyObject]?
    private(set) var segmentWithUser: Bool = false
    private(set) var segmentMode: SegmentMode = .Partial
    private(set) var offlinePolicy: Halo.OfflinePolicy?
    private(set) var locale: Halo.Locale?

    public override var hash: Int {
        return body.map { "\($0)-\($1.description!)" }.joinWithSeparator("+").hash
    }

    public var body: [String: AnyObject] {
        var dict = [String: AnyObject]()

        if let modules = self.moduleIds {
            dict[Keys.ModuleIds] = modules
        }

        if let moduleName = self.moduleName {
            dict[Keys.ModuleName] = moduleName
        }
        
        if let instances = self.instanceIds {
            dict[Keys.InstanceIds] = instances
        }

        if let searchValues = self.conditions {
            dict[Keys.SearchValues] = searchValues
        }

        if let metaSearch = self.metaConditions {
            dict[Keys.MetaSearch] = metaSearch
        }

        if let fields = self.fields {
            dict[Keys.Fields] = fields
        }

        if let tags = self.tags {
            dict[Keys.Tags] = tags.map { $0.toDictionary() }
        }

        if let include = self.populateFields {
            dict[Keys.Include] = include
        }

        if let pagination = self.pagination {
            dict[Keys.Pagination] = pagination
        }

        if self.segmentWithUser {
            if let user = Halo.Manager.core.user, tags = user.tags {
                if tags.count > 0 {
                    dict[Keys.SegmentTags] = tags.values.map { $0.toDictionary() }
                }
            }
        }

        dict[Keys.SegmentMode] = self.segmentMode.description

        if let locale = self.locale {
            dict[Keys.Locale] = locale.description
        }

        return dict
    }

    public func searchFilter(filter: SearchFilter) -> Halo.SearchQuery {
        self.conditions = filter.body
        return self
    }

    public func metaFilter(filter: SearchFilter) -> Halo.SearchQuery {
        self.metaConditions = filter.body
        return self
    }

    public func fields(fields: [String]) -> Halo.SearchQuery {
        self.fields = fields
        return self
    }

    public func tags(tags: [Halo.Tag]) -> Halo.SearchQuery {
        self.tags = tags
        return self
    }

    public func moduleIds(ids: [String]) -> Halo.SearchQuery {
        self.moduleIds = ids
        return self
    }

    public func moduleName(name: String) -> Halo.SearchQuery {
        self.moduleName = name
        return self
    }
    
    public func instanceIds(ids: [String]) -> Halo.SearchQuery {
        self.instanceIds = ids
        return self
    }

    public func populateFields(fields: [String]) -> Halo.SearchQuery {
        self.populateFields = fields
        return self
    }

    public func populateAll() -> Halo.SearchQuery {
        self.populateFields = ["all"]
        return self
    }

    public func segmentWithUser(segment: Bool) -> Halo.SearchQuery {
        self.segmentWithUser = segment
        return self
    }

    public func segmentMode(mode: SegmentMode) -> Halo.SearchQuery {
        self.segmentMode = mode
        return self
    }

    public func locale(locale: Halo.Locale) -> Halo.SearchQuery {
        self.locale = locale
        return self
    }

    public func skipPagination() -> Halo.SearchQuery {
        self.pagination = ["skip": "true"]
        return self
    }

    public func pagination(page: Int, limit: Int) -> Halo.SearchQuery {
        self.pagination = [
            "page"  : page,
            "limit" : limit,
            "skip"  : "false"
        ]
        return self
    }

    public func offlinePolicy(policy: Halo.OfflinePolicy) -> Halo.SearchQuery {
        self.offlinePolicy = policy
        return self
    }
}
