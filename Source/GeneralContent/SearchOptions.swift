//
//  SearchOptions.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public enum SegmentMode: String {
    case Total = "total",
    Partial = "partial"
}

public struct SearchOptions {

    var moduleIds: [String]?
    var instanceIds: [String]?
    var conditions: [String: AnyObject]?
    var metaConditions: [String: AnyObject]?
    var fields: [String]?
    var populateFields: [String]?
    var tags: [Halo.Tag]?
    var pagination: [String: AnyObject]?
    var segmentWithUser: Bool = false
    var segmentMode: SegmentMode = .Partial
    var offlinePolicy: Halo.OfflinePolicy?
    var locale: Halo.Locale?

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

        if self.segmentWithUser {
            if let user = Halo.Manager.core.user, tags = user.tags {
                if tags.count > 0 {
                    dict["segmentTags"] = tags.values.map { $0.toDictionary() }
                }
            }
        }

        dict["segmentMode"] = self.segmentMode.rawValue

        if let locale = self.locale {
            dict["locale"] = locale.description
        }

        return dict
    }

    public init() {}

    public mutating func setSearchFilter(filter: SearchFilter) -> Halo.SearchOptions {
        self.conditions = filter.body
        return self
    }

    public mutating func setMetaFilter(filter: SearchFilter) -> Halo.SearchOptions {
        self.metaConditions = filter.body
        return self
    }

    public mutating func setFields(fields: [String]) -> Halo.SearchOptions {
        self.fields = fields
        return self
    }

    public mutating func setTags(tags: [Halo.Tag]) -> Halo.SearchOptions {
        self.tags = tags
        return self
    }

    public mutating func setModuleIds(ids: [String]) -> Halo.SearchOptions {
        self.moduleIds = ids
        return self
    }

    public mutating func setInstanceIds(ids: [String]) -> Halo.SearchOptions {
        self.instanceIds = ids
        return self
    }

    public mutating func setPopulateFields(fields: [String]) -> Halo.SearchOptions {
        self.populateFields = fields
        return self
    }

    public mutating func populateAll() -> Halo.SearchOptions {
        self.populateFields = ["all"]
        return self
    }

    public mutating func segmentWithUser(segment: Bool) -> Halo.SearchOptions {
        self.segmentWithUser = segment
        return self
    }

    public mutating func segmentMode(mode: SegmentMode) -> Halo.SearchOptions {
        self.segmentMode = mode
        return self
    }

    public mutating func setLocale(locale: Halo.Locale) -> Halo.SearchOptions {
        self.locale = locale
        return self
    }

    public mutating func skipPagination() -> Halo.SearchOptions {
        self.pagination = ["skip": "true"]
        return self
    }

    public mutating func setPagination(page: Int, limit: Int) -> Halo.SearchOptions {
        self.pagination = [
            "page"  : page,
            "limit" : limit,
            "skip"  : "false"
        ]
        return self
    }

    public mutating func setOfflinePolicy(policy: Halo.OfflinePolicy) -> Halo.SearchOptions {
        self.offlinePolicy = policy
        return self
    }

}
