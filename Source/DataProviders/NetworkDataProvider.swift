//
//  NetworkDataProvider.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

open class NetworkDataProvider: DataProvider {

    open func getModules(completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<PaginatedModules?>) -> Void) -> Void {

        let request = Halo.Request<PaginatedModules>(router: Router.modules).skipPagination().responseParser { (data) in

            var result: PaginatedModules? = nil

            switch data {
            case let d as [String: AnyObject]: // Paginated response
                if let pag = d["pagination"] as? [String: AnyObject], let items = d["items"] as? [[String: AnyObject]] {
                    let paginationInfo = PaginationInfo.fromDictionary(dict: pag)
                    let items = items.map { Halo.Module.fromDictionary(dict: $0) }
                    result = PaginatedModules(paginationInfo: paginationInfo, modules: items)
                }
            case let d as [[String: AnyObject]]: // Non-paginated response
                let items = d.map { Halo.Module.fromDictionary(dict: $0) }
                let paginationInfo = PaginationInfo(page: 1, limit: items.count, offset: 0, totalItems: items.count, totalPages: 1)
                result = PaginatedModules(paginationInfo: paginationInfo, modules: items)
            default: // Everything else
                break
            }

            return result
        }

        _ = try? request.responseObject(completionHandler: handler)

    }

    open func search(query: Halo.SearchQuery, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void {

        let request = Halo.Request<PaginatedContentInstances>(router: Router.generalContentSearch).params(params: query.body).responseParser { data in

            var result: PaginatedContentInstances? = nil

            switch data {
            case let d as [String: AnyObject]: // Paginated response
                if let pag = d["pagination"] as? [String: AnyObject], let items = d["items"] as? [[String: AnyObject]] {
                    let paginationInfo = PaginationInfo.fromDictionary(dict: pag)
                    let items = items.map { Halo.ContentInstance.fromDictionary(dict: $0) }
                    result = PaginatedContentInstances(paginationInfo: paginationInfo, instances: items)
                }
            case let d as [[String: AnyObject]]: // Non-paginated response
                let items = d.map { Halo.ContentInstance.fromDictionary(dict: $0) }
                let paginationInfo = PaginationInfo(page: 1, limit: items.count, offset: 0, totalItems: items.count, totalPages: 1)
                result = PaginatedContentInstances(paginationInfo: paginationInfo, instances: items)
            default: // Everything else
                break
            }

            return result

        }

        _ = try? request.responseObject(completionHandler: handler)


    }

}
