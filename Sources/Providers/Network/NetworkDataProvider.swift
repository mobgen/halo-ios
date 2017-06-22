//
//  NetworkDataProvider.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

open class NetworkDataProvider: DataProvider {

    fileprivate let instanceParser: (Any?) -> ContentInstance? = { data in
        guard let d = data as? [String: Any] else {
            return nil
        }
        
        return ContentInstance.fromDictionary(d)
    }
    
    fileprivate let batchResultParser: (Any?) -> BatchResult? = { data in
        guard let d = data as? [String: Any] else {
            return nil
        }
        
        return BatchResult.fromDictionary(d)
    }
    
    open func getModules(query: ModulesQuery, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<PaginatedModules?>) -> Void) -> Void {

        let request = Halo.Request<PaginatedModules>(router: Router.modules).skipPagination().serverCache(query.serverCache).responseParser { (data) in

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

        do {
            try request.responseObject(handler)
        } catch let e where e is HaloError {
            handler(nil, .failure(e as! HaloError))
        } catch {
            handler(nil, .failure(.unknownError(error)))
        }

    }

    public func search(query: Halo.SearchQuery, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void {

        let request = Halo.Request<PaginatedContentInstances>(router: Router.instanceSearch(query.body)).serverCache(query.serverCache).responseParser { data in

            var result: PaginatedContentInstances? = nil

            switch data {
            case let d as [String: AnyObject]: // Paginated response
                if let pag = d["pagination"] as? [String: AnyObject], let items = d["items"] as? [[String: AnyObject]] {
                    let paginationInfo = PaginationInfo.fromDictionary(dict: pag)
                    let items = items.map { Halo.ContentInstance.fromDictionary($0) }
                    result = PaginatedContentInstances(paginationInfo: paginationInfo, instances: items)
                }
            case let d as [[String: AnyObject]]: // Non-paginated response
                let items = d.map { Halo.ContentInstance.fromDictionary($0) }
                let paginationInfo = PaginationInfo(page: 1, limit: items.count, offset: 0, totalItems: items.count, totalPages: 1)
                result = PaginatedContentInstances(paginationInfo: paginationInfo, instances: items)
            default: // Everything else
                break
            }

            return result

        }

        do {
            try request.responseObject(handler)
        } catch let e where e is HaloError {
            handler(nil, .failure(e as! HaloError))
        } catch {
            handler(nil, .failure(.unknownError(error)))
        }


    }

    public func searchAsData(query: SearchQuery, completionHandler handler: @escaping (HTTPURLResponse?, Result<Data>) -> Void) {

        let request = Halo.Request<Any>(router: Router.instanceSearch(query.body))

        do {
            try request.responseData(handler)
        } catch let e where e is HaloError {
            handler(nil, .failure(e as! HaloError))
        } catch {
            handler(nil, .failure(.unknownError(error)))
        }

    }

    public func save(instance: ContentInstance, completionHandler handler: @escaping (HTTPURLResponse?, Result<ContentInstance?>) -> Void) -> Void {
        
        var router: Router
        
        if let id = instance.id {
            router = Router.instanceUpdate(id, instance.toDictionary())
        } else {
            router = Router.instanceCreate(instance.toDictionary())
        }
        
        let request = Halo.Request<ContentInstance>(router: router).responseParser(instanceParser)
        
        do {
            try request.responseObject(handler)
        } catch let e where e is HaloError {
            handler(nil, .failure(e as! HaloError))
        } catch {
            handler(nil, .failure(.unknownError(error)))
        }
        
    }
    
    public func delete(id: String, completionHandler handler: @escaping (HTTPURLResponse?, Result<ContentInstance?>) -> Void) -> Void {
        
        let request = Halo.Request<ContentInstance>(router: Router.instanceDelete(id)).responseParser(instanceParser)
        
        do {
            try request.responseObject(handler)
        } catch let e where e is HaloError {
            handler(nil, .failure(e as! HaloError))
        } catch {
            handler(nil, .failure(.unknownError(error)))
        }
    }
    
    public func batch(operations: BatchOperations, completionHandler handler: @escaping (HTTPURLResponse?, Result<BatchResult?>) -> Void) {
        
        let request = Halo.Request<BatchResult>(router: Router.instanceBatch(operations.body)).responseParser(batchResultParser)
        
        do {
            try request.responseObject(handler)
        } catch let e where e is HaloError {
            handler(nil, .failure(e as! HaloError))
        } catch {
            handler(nil, .failure(.unknownError(error)))
        }
        
    }
    
}
