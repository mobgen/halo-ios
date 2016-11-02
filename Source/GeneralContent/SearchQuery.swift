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
    fileprivate(set) var conditions: [String: AnyObject]?
    fileprivate(set) var metaConditions: [String: AnyObject]?
    fileprivate(set) var fields: [String]?
    fileprivate(set) var populateFields: [String]?
    fileprivate(set) var tags: [Halo.Tag]?
    fileprivate(set) var pagination: [String: AnyObject]?
    fileprivate(set) var segmentWithDevice: Bool = false
    fileprivate(set) var segmentMode: SegmentMode = .partial
    fileprivate(set) var offlinePolicy: Halo.OfflinePolicy?
    fileprivate(set) var locale: Halo.Locale?

    open override var hash: Int {
        let values: [String] = body.map { "\($0)-\($1.description!)" }
        return values.joined(separator: "+").hash
    }

    open var body: [String: AnyObject] {
        var dict = [String: AnyObject]()

        if let modules = self.moduleIds {
            dict.updateValue(modules as AnyObject, forKey: Keys.ModuleIds)
        }

        if let moduleName = self.moduleName {
            dict.updateValue(moduleName as AnyObject, forKey: Keys.ModuleName)
        }
        
        if let instances = self.instanceIds {
            dict.updateValue(instances as AnyObject, forKey: Keys.InstanceIds)
        }

        if let searchValues = self.conditions {
            dict.updateValue(searchValues as AnyObject, forKey: Keys.SearchValues)
        }

        if let metaSearch = self.metaConditions {
            dict.updateValue(metaSearch as AnyObject, forKey: Keys.MetaSearch)
        }

        if let fields = self.fields {
            dict.updateValue(fields as AnyObject, forKey: Keys.Fields)
        }

        if let tags = self.tags {
            let tagsList = tags.map { $0.toDictionary() } as AnyObject
            dict.updateValue(tagsList, forKey: Keys.Tags)
        }

        if let include = self.populateFields {
            dict.updateValue(include as AnyObject, forKey: Keys.Include)
        }

        if let pagination = self.pagination {
            dict.updateValue(pagination as AnyObject, forKey: Keys.Pagination)
        }

        if self.segmentWithDevice {
            if let device = Halo.Manager.core.device, let tags = device.tags {
                if tags.count > 0 {
                    dict.updateValue(tags.values.map { $0.toDictionary() } as AnyObject, forKey: Keys.SegmentTags)
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
    open func searchFilter(filter: SearchFilter) -> Halo.SearchQuery {
        self.conditions = filter.body
        return self
    }

    @objc(metaFilter:)
    open func metaFilter(filter: SearchFilter) -> Halo.SearchQuery {
        self.metaConditions = filter.body
        return self
    }

    @objc(fields:)
    open func fields(fields: [String]) -> Halo.SearchQuery {
        self.fields = fields
        return self
    }

    @objc(tags:)
    open func tags(tags: [Halo.Tag]) -> Halo.SearchQuery {
        self.tags = tags
        return self
    }

    @objc(moduleIds:)
    open func moduleIds(ids: [String]) -> Halo.SearchQuery {
        self.moduleIds = ids
        return self
    }

    @objc(moduleName:)
    open func moduleName(name: String) -> Halo.SearchQuery {
        self.moduleName = name
        return self
    }
    
    @objc(instanceIds:)
    open func instanceIds(ids: [String]) -> Halo.SearchQuery {
        self.instanceIds = ids
        return self
    }

    @objc(populateFields:)
    open func populateFields(fields: [String]) -> Halo.SearchQuery {
        self.populateFields = fields
        return self
    }

    open func populateAll() -> Halo.SearchQuery {
        self.populateFields = ["all"]
        return self
    }

    @objc(segmentWithDevice:)
    open func segmentWithDevice(segment: Bool) -> Halo.SearchQuery {
        self.segmentWithDevice = segment
        return self
    }

    @objc(segmentMode:)
    open func segmentMode(mode: SegmentMode) -> Halo.SearchQuery {
        self.segmentMode = mode
        return self
    }

    @objc(locale:)
    open func locale(locale: Halo.Locale) -> Halo.SearchQuery {
        self.locale = locale
        return self
    }

    open func skipPagination() -> Halo.SearchQuery {
        self.pagination = ["skip": "true" as AnyObject]
        return self
    }

    @objc(paginationWithPage:limit:)
    open func pagination(page: Int, limit: Int) -> Halo.SearchQuery {
        self.pagination = [
            "page"  : page as AnyObject,
            "limit" : limit as AnyObject,
            "skip"  : "false" as AnyObject
        ]
        return self
    }
}
