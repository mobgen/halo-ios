//
//  GeneralContent.swift
//  HaloSDK
//
//  Created by Borja on 31/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/**
 Access point to the General Content. This class will provide methods to obtain the data stored as general content.
 */
public struct ContentManager: HaloManager {

    public var defaultLocale: Halo.Locale?

    init() {}

    public func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {

    }

    // MARK: Get instances

    public func getInstances(searchOptions: Halo.SearchQuery) -> Halo.Request<PaginatedContentInstances> {

        let request = Halo.Request<PaginatedContentInstances>(router: Router.GeneralContentSearch).responseParser { (any) in

            switch any {
            case let data as [String: AnyObject]:

                if let pag = data["pagination"] as? [String: AnyObject], items = data["items"] as? [[String: AnyObject]] {
                    let paginationInfo = PaginationInfo.fromDictionary(pag)
                    let instances = items.map { Halo.ContentInstance.fromDictionary($0) }
                    return PaginatedContentInstances(paginationInfo: paginationInfo, instances: instances)
                }
                return nil

            case let data as [[String: AnyObject]]:

                let items = data.map { Halo.ContentInstance.fromDictionary($0) }
                let paginationInfo = PaginationInfo(page: 1, limit: items.count, offset: 0, totalItems: items.count, totalPages: 1)
                return PaginatedContentInstances(paginationInfo: paginationInfo, instances: items)

            default:
                return nil
            }
        }

        // Check offline mode
        if let offline = searchOptions.offlinePolicy {
            request.offlinePolicy(offline)
        }

        // Set the provided locale or fall back to the default one
        searchOptions.locale = searchOptions.locale ?? self.defaultLocale

        // Process the search options
        request.params(searchOptions.body)

        return request
    }

}
