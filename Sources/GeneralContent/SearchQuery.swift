//
//  SearchOptions.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloSegmentMode)
public enum SegmentMode: Int {
    case total, partial

    public var description: String {
        switch self {
        case .total: return "total"
        case .partial: return "partial"
        }
    }
}

@objc(HaloSortBy)
public enum SortBy: Int {
    case name, createdAt, updatedAt, publishedAt, removedAt, archivedAt, deletedAt
    
    public var description: String {
        switch self {
        case .name: return "name"
        case .createdAt: return "createdAt"
        case .updatedAt: return "updatedAt"
        case .publishedAt: return "publishedAt"
        case .removedAt: return "removedAt"
        case .archivedAt: return "archivedAt"
        case .deletedAt: return "deletedAt"
        }
    }
}

@objc(HaloSortingOrder)
public enum SortingOrder: Int {
    case ascending, descending
    
    public var description: String {
        switch self {
        case .ascending: return "asc"
        case .descending: return "desc"
        }
    }
}

@objc(HaloSearchQuery)
open class SearchQuery: NSObject {

    struct Keys {
        static let ModuleName = "moduleName"
        static let ModuleIds = "moduleIds"
        static let InstanceIds = "instanceIds"
        static let RelatedTo = "relatedTo"
        static let RelatedToFieldName = "fieldName"
        static let RelatedToInstanceIds = "instanceIds"
        static let SearchValues = "searchValues"
        static let MetaSearch = "metaSearch"
        static let Fields = "fields"
        static let Tags = "segmentTags"
        static let Include = "include"
        static let Pagination = "pagination"
        static let SegmentTags = "segmentTags"
        static let SegmentMode = "segmentMode"
        static let Sort = "sort"
        static let Locale = "locale"
    }

    private(set) var moduleName: String?
    private(set) var moduleIds: [String]?
    private(set) var instanceIds: [String]?
    private(set) var relatedTo: [[String: Any]] = []
    private(set) var conditions: [String: Any]?
    private(set) var metaConditions: [String: Any]?
    private(set) var fields: [String]?
    private(set) var populateFields: [String]?
    private(set) var tags: [Halo.Tag]?
    private(set) var pagination: [String: Any]?
    private(set) var segmentWithDevice: Bool = false
    private(set) var segmentMode: SegmentMode = .partial
    private(set) var sortingParams: [String] = []
    private(set) var offlinePolicy: Halo.OfflinePolicy?
    private(set) var locale: Halo.Locale?
    private(set) var serverCache: Int = 0

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
            dict[Keys.ModuleIds] = modules
        }

        if let moduleName = self.moduleName {
            dict[Keys.ModuleName] = moduleName
        }
        
        if let instances = self.instanceIds {
            dict[Keys.InstanceIds] = instances
        }

        if self.relatedTo.count > 0 {
            dict[Keys.RelatedTo] = self.relatedTo
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
            let tagsList = tags.map { $0.toDictionary() }
            dict[Keys.SegmentTags] = tagsList
        }

        if let include = self.populateFields {
            dict[Keys.Include] = include
        }

        if let pagination = self.pagination {
            dict[Keys.Pagination] = pagination
        }

        if self.segmentWithDevice {
            if let device = Halo.Manager.core.device, let tags = device.tags {
                if tags.count > 0 {
                    if dict[Keys.SegmentTags] != nil {
                        let userTags = tags.map { $1.toDictionary() }
                        var existingItems = dict[Keys.SegmentTags] as? [[String: Any]] ?? [[String: Any]]()
                        userTags.forEach({ (tag) in
                            existingItems.append(tag)
                        })
                        dict[Keys.SegmentTags] = existingItems
                    } else {
                        dict[Keys.SegmentTags] = tags.map { $1.toDictionary() }
                    }
                }
            }
        }

        dict[Keys.SegmentMode] = self.segmentMode.description

        if self.sortingParams.count > 0 {
            dict[Keys.Sort] = self.sortingParams.joined(separator: ",")
        }
        
        if let locale = self.locale {
            dict[Keys.Locale] = locale.description
        }

        return dict
    }

    // MARK: Setters
    
    @objc(addAllRelatedInstancesWithFieldName:)
    @discardableResult
    open func addAllRelatedInstances(fieldName: String) -> Halo.SearchQuery {
        self.relatedTo.append([
            Keys.RelatedToFieldName: fieldName,
            Keys.RelatedToInstanceIds: ["*"]
            ])
        return self
    }
    
    @objc(searchFilter:)
    @discardableResult
    open func searchFilter(_ filter: SearchFilter) -> Halo.SearchQuery {
        self.conditions = filter.body
        return self
    }

    @objc(metaFilter:)
    @discardableResult
    open func metaFilter(_ filter: SearchFilter) -> Halo.SearchQuery {
        self.metaConditions = filter.body
        return self
    }

    @objc(fields:)
    @discardableResult
    open func fields(_ fields: [String]) -> Halo.SearchQuery {
        self.fields = fields
        return self
    }

    @objc(tags:)
    @discardableResult
    open func tags(_ tags: [Halo.Tag]) -> Halo.SearchQuery {
        self.tags = tags
        return self
    }

    @objc(moduleIds:)
    @discardableResult
    open func moduleIds(_ ids: [String]) -> Halo.SearchQuery {
        self.moduleIds = ids
        return self
    }

    @objc(addRelatedInstancesWithFieldName:instanceIds:)
    @discardableResult
    open func addRelatedInstances(fieldName: String, instanceIds: [String]) -> Halo.SearchQuery {
        self.relatedTo.append([
            Keys.RelatedToFieldName: fieldName,
            Keys.RelatedToInstanceIds: instanceIds
        ])
        return self
    }
    
    @objc(moduleName:)
    @discardableResult
    open func moduleName(_ name: String) -> Halo.SearchQuery {
        self.moduleName = name
        return self
    }
    
    @objc(instanceIds:)
    @discardableResult
    open func instanceIds(_ ids: [String]) -> Halo.SearchQuery {
        self.instanceIds = ids
        return self
    }

    @objc(populateFields:)
    @discardableResult
    open func populateFields(_ fields: [String]) -> Halo.SearchQuery {
        self.populateFields = fields
        return self
    }

    @objc(populateAll)
    @discardableResult
    open func populateAll() -> Halo.SearchQuery {
        self.populateFields = ["all"]
        return self
    }

    @objc(segmentWithDevice:)
    @discardableResult
    open func segmentWithDevice(_ segment: Bool) -> Halo.SearchQuery {
        self.segmentWithDevice = segment
        return self
    }

    @objc(segmentMode:)
    @discardableResult
    open func segmentMode(_ mode: SegmentMode) -> Halo.SearchQuery {
        self.segmentMode = mode
        return self
    }

    @objc(locale:)
    @discardableResult
    open func locale(_ locale: Halo.Locale) -> Halo.SearchQuery {
        self.locale = locale
        return self
    }

    @objc(skipPagination)
    @discardableResult
    open func skipPagination() -> Halo.SearchQuery {
        self.pagination = ["skip": "true"]
        return self
    }

    @objc(paginationWithPage:limit:)
    @discardableResult
    open func pagination(page: Int, limit: Int) -> Halo.SearchQuery {
        self.pagination = [
            "page"  : page,
            "limit" : limit,
            "skip"  : "false"
        ]
        return self
    }
    
    @objc(addSortByField:order:)
    @discardableResult
    open func addSortBy(field: SortBy, order: SortingOrder) -> Halo.SearchQuery {
        self.sortingParams.append("\(field.description) \(order.description)")
        return self
    }
    
    @objc(serverCache:)
    @discardableResult
    open func serverCache(seconds: Int) -> Halo.SearchQuery {
        self.serverCache = seconds
        return self
    }
}
