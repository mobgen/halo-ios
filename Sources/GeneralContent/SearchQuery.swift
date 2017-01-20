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
    case total, partial

    public var description: String {
        switch self {
        case .total: return "total"
        case .partial: return "partial"
        }
    }
}

@objc(HaloSearchQuery)
open class SearchQuery: NSObject {

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

    fileprivate(set) var moduleName: String?
    fileprivate(set) var moduleIds: [String]?
    fileprivate(set) var instanceIds: [String]?
    fileprivate(set) var conditions: [String: Any]?
    fileprivate(set) var metaConditions: [String: Any]?
    fileprivate(set) var fields: [String]?
    fileprivate(set) var populateFields: [String]?
    fileprivate(set) var tags: [Halo.Tag]?
    fileprivate(set) var pagination: [String: Any]?
    fileprivate(set) var segmentWithDevice: Bool = false
    fileprivate(set) var segmentMode: SegmentMode = .partial
    fileprivate(set) var offlinePolicy: Halo.OfflinePolicy?
    fileprivate(set) var locale: Halo.Locale?

    open override var hash: Int {
        let values: [String] = body.map { key, value in
            switch value {
            case let v as AnyObject:
                return "\(key)-\(v.description)"
            default:
                return ""
            }
        }
        return values.joined(separator: "+").hash
    }

    open var body: [String: Any] {
        var dict = [String: Any]()

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
            let tagsList = tags.map { $0.toDictionary() }
            dict.updateValue(tagsList, forKey: Keys.Tags)
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
                    dict.updateValue(tags.map { $1.toDictionary() }, forKey: Keys.SegmentTags)
                }
            }
        }

        dict[Keys.SegmentMode] = self.segmentMode.description as AnyObject?

        if let locale = self.locale {
            dict[Keys.Locale] = locale.description as AnyObject?
        }

        return dict
    }

    @objc(searchFilter:)
    open func searchFilter(_ filter: SearchFilter) -> Halo.SearchQuery {
        self.conditions = filter.body
        return self
    }

    @objc(metaFilter:)
    open func metaFilter(_ filter: SearchFilter) -> Halo.SearchQuery {
        self.metaConditions = filter.body
        return self
    }

    @objc(fields:)
    open func fields(_ fields: [String]) -> Halo.SearchQuery {
        self.fields = fields
        return self
    }

    @objc(tags:)
    open func tags(_ tags: [Halo.Tag]) -> Halo.SearchQuery {
        self.tags = tags
        return self
    }

    @objc(moduleIds:)
    open func moduleIds(_ ids: [String]) -> Halo.SearchQuery {
        self.moduleIds = ids
        return self
    }

    @objc(moduleName:)
    open func moduleName(_ name: String) -> Halo.SearchQuery {
        self.moduleName = name
        return self
    }
    
    @objc(instanceIds:)
    open func instanceIds(_ ids: [String]) -> Halo.SearchQuery {
        self.instanceIds = ids
        return self
    }

    @objc(populateFields:)
    open func populateFields(_ fields: [String]) -> Halo.SearchQuery {
        self.populateFields = fields
        return self
    }

    open func populateAll() -> Halo.SearchQuery {
        self.populateFields = ["all"]
        return self
    }

    @objc(segmentWithDevice:)
    open func segmentWithDevice(_ segment: Bool) -> Halo.SearchQuery {
        self.segmentWithDevice = segment
        return self
    }

    @objc(segmentMode:)
    open func segmentMode(_ mode: SegmentMode) -> Halo.SearchQuery {
        self.segmentMode = mode
        return self
    }

    @objc(locale:)
    open func locale(_ locale: Halo.Locale) -> Halo.SearchQuery {
        self.locale = locale
        return self
    }

    open func skipPagination() -> Halo.SearchQuery {
        self.pagination = ["skip": "true"]
        return self
    }

    @objc(paginationWithPage:limit:)
    open func pagination(page: Int, limit: Int) -> Halo.SearchQuery {
        self.pagination = [
            "page"  : page,
            "limit" : limit,
            "skip"  : "false"
        ]
        return self
    }
}
