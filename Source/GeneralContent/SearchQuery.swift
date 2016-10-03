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
    private(set) var segmentWithDevice: Bool = false
    private(set) var segmentMode: SegmentMode = .Partial
    private(set) var offlinePolicy: Halo.OfflinePolicy?
    private(set) var locale: Halo.Locale?

    public override var hash: Int {
        let values: [String] = body.map { "\($0)-\($1.description!)" }
        return values.joinWithSeparator("+").hash
    }

    public var body: [String: AnyObject] {
        var dict = [String: AnyObject]()

        if let modules = self.moduleIds {
            dict.updateValue(modules, forKey: Keys.ModuleIds)
        }

        if let moduleName = self.moduleName {
            dict.updateValue(moduleName, forKey: Keys.ModuleName)
        }
        
        if let instances = self.instanceIds {
            dict.updateValue(instances, forKey: Keys.InstanceIds)
        }

        if let searchValues = self.conditions {
            dict.updateValue(searchValues, forKey: Keys.SearchValues)
        }

        if let metaSearch = self.metaConditions {
            dict.updateValue(metaSearch, forKey: Keys.MetaSearch)
        }

        if let fields = self.fields {
            dict.updateValue(fields, forKey: Keys.Fields)
        }

        if let tags = self.tags {
            dict.updateValue(tags.map { $0.toDictionary() }, forKey: Keys.Tags)
        }

        if let include = self.populateFields {
            dict.updateValue(include, forKey: Keys.Include)
        }

        if let pagination = self.pagination {
            dict.updateValue(pagination, forKey: Keys.Pagination)
        }

        if self.segmentWithDevice {
            if let device = Halo.Manager.core.device, let tags = device.tags {
                if tags.count > 0 {
                    dict.updateValue(tags.values.map { $0.toDictionary() }, forKey: Keys.SegmentTags)
                }
            }
        }

        dict[Keys.SegmentMode] = self.segmentMode.description

        if let locale = self.locale {
            dict[Keys.Locale] = locale.description
        }

        return dict
    }

    @objc(searchFilter:)
    public func searchFilter(filter filter: SearchFilter) -> Halo.SearchQuery {
        self.conditions = filter.body
        return self
    }

    @objc(metaFilter:)
    public func metaFilter(filter filter: SearchFilter) -> Halo.SearchQuery {
        self.metaConditions = filter.body
        return self
    }

    @objc(fields:)
    public func fields(fields fields: [String]) -> Halo.SearchQuery {
        self.fields = fields
        return self
    }

    @objc(tags:)
    public func tags(tags tags: [Halo.Tag]) -> Halo.SearchQuery {
        self.tags = tags
        return self
    }

    @objc(moduleIds:)
    public func moduleIds(ids ids: [String]) -> Halo.SearchQuery {
        self.moduleIds = ids
        return self
    }

    @objc(moduleName:)
    public func moduleName(name name: String) -> Halo.SearchQuery {
        self.moduleName = name
        return self
    }
    
    @objc(instanceIds:)
    public func instanceIds(ids ids: [String]) -> Halo.SearchQuery {
        self.instanceIds = ids
        return self
    }

    @objc(populateFields:)
    public func populateFields(fields fields: [String]) -> Halo.SearchQuery {
        self.populateFields = fields
        return self
    }

    public func populateAll() -> Halo.SearchQuery {
        self.populateFields = ["all"]
        return self
    }

    @objc(segmentWithDevice:)
    public func segmentWithDevice(segment segment: Bool) -> Halo.SearchQuery {
        self.segmentWithDevice = segment
        return self
    }

    @objc(segmentMode:)
    public func segmentMode(mode mode: SegmentMode) -> Halo.SearchQuery {
        self.segmentMode = mode
        return self
    }

    @objc(locale:)
    public func locale(locale locale: Halo.Locale) -> Halo.SearchQuery {
        self.locale = locale
        return self
    }

    public func skipPagination() -> Halo.SearchQuery {
        self.pagination = ["skip": "true"]
        return self
    }

    @objc(paginationWithPage:limit:)
    public func pagination(page page: Int, limit: Int) -> Halo.SearchQuery {
        self.pagination = [
            "page"  : page,
            "limit" : limit,
            "skip"  : "false"
        ]
        return self
    }
}
