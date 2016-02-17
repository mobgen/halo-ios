//
//  NetworkManager+GeneralContent.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 05/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

public struct GeneralContentFlag : OptionSetType {
    
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let IncludeArchived = GeneralContentFlag(rawValue: 1)
    public static let IncludeUnpublished = GeneralContentFlag(rawValue: 2)
}

extension NetworkManager {

    /**
    Obtain the existing instances for a given General Content module

    - parameter moduleId:           Internal id of the module to be requested
    - parameter completionHandler:  Closure to be executed when the request has finished
    */
    func generalContentInstances(moduleIds moduleIds: [String],
        flags: GeneralContentFlag? = [],
        populate: Bool? = false,
        completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)? = nil) -> Void {
            
            let unpublished = flags!.contains(GeneralContentFlag.IncludeUnpublished)
            
            let req = self.generalContentInstancesRequest(moduleIds: moduleIds, instanceIds: nil, flags: flags, populate: populate, page: nil, limit: nil)
            
            req.response { result in
                switch result {
                case .Success(let data as [[String:AnyObject]], let cached):
                    let arr = self.parseGeneralContentInstances(data, includeUnpublished: unpublished)
                    handler?(.Success(arr, cached))
                case .Failure(let error):
                    handler?(.Failure(error))
                default:
                    handler?(.Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
                }
            }
    }

    func generalContentInstances(moduleIds moduleIds: [String],
        flags: GeneralContentFlag? = [],
        populate: Bool? = false,
        page: Int,
        limit: Int,
        completionHandler handler: ((Halo.PaginatedResult<[Halo.GeneralContentInstance], NSError>) -> Void)? = nil) -> Void {
            
            let unpublished = flags!.contains(GeneralContentFlag.IncludeUnpublished)
            
            let req = self.generalContentInstancesRequest(moduleIds: moduleIds, instanceIds: nil, flags: flags, populate: populate, page: page, limit: limit)
            
            req.response { result in
                switch result {
                case .Success(let data as [String:AnyObject], let cached):
                    // Paginated result
                    let arr = self.parseGeneralContentInstances(data["items"] as! [[String:AnyObject]], includeUnpublished: unpublished)
                    
                    // Get pagination info
                    let paginationInfo = data["pagination"] as! [String: AnyObject]
                    let count = paginationInfo["count"] as! Int
                    
                    handler?(.Success(arr, page, limit, count, cached))
                case .Failure(let error):
                    handler?(.Failure(error))
                default:
                    break
                }
            }
    }
    
    func generalContentInstance(instanceId: String,
        populate: Bool? = false,
        completionHandler handler: ((Halo.Result<Halo.GeneralContentInstance, NSError>) -> Void)? = nil) -> Void {
        
        let params: [String: AnyObject] = ["populate" : populate!]
        
        let req = Halo.Request(router: Router.GeneralContentInstance(instanceId, params))
            
        req.response { result in
            switch result {
            case .Success(let data as [String:AnyObject], let cached):
                handler?(.Success(GeneralContentInstance(data), cached))
            case .Failure(let error):
                handler?(.Failure(error))
            default:
                handler?(.Failure(NSError(domain: "com.mobgen.halo", code: -1, userInfo: nil)))
            }
        }
            
    }
    
    func generalContentInstances(instanceIds instanceIds: [String],
        flags: GeneralContentFlag? = [],
        populate: Bool? = false,
        completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)? = nil) -> Void {
            
            let req = self.generalContentInstancesRequest(moduleIds: nil, instanceIds: instanceIds, flags: flags, populate: populate, page: nil, limit: nil)
            
            req.response { result in
                
                switch result {
                case .Success(let data as [[String: AnyObject]], let cached):
                    let items = data.map({ GeneralContentInstance($0) })
                    handler?(.Success(items, cached))
                case .Failure(let error):
                    handler?(.Failure(error))
                default:
                    break
                }
            }
    }
    
    func generalContentInstances(instanceIds instanceIds: [String],
        flags: GeneralContentFlag? = [],
        populate: Bool? = false,
        page: Int,
        limit: Int,
        completionHandler handler: ((Halo.PaginatedResult<[Halo.GeneralContentInstance], NSError>) -> Void)? = nil) -> Void {
     
            let req = self.generalContentInstancesRequest(moduleIds: nil, instanceIds: instanceIds, flags: flags, populate: populate, page: page, limit: limit)
            
            req.response { result in
                switch result {
                case .Success(let data as [String: AnyObject], let cached):
                    // Paginated response
                    let items = self.parseGeneralContentInstances(data["items"] as! [[String: AnyObject]], includeUnpublished: true)
                    
                    let paginationInfo = data["pagination"] as! [String: AnyObject]
                    let count = paginationInfo["count"] as! Int
                    
                    handler?(.Success(items, page, limit, count, cached))
                case .Failure(let error):
                    handler?(.Failure(error))
                default:
                    break
                }
            }
    }
    
    private func generalContentInstancesRequest(moduleIds moduleIds: [String]?,
        instanceIds: [String]?,
        flags: GeneralContentFlag? = [],
        populate: Bool? = false,
        page: Int? = nil,
        limit: Int? = nil) -> Halo.Request {
            
            var params: [String: AnyObject] = [
                "populate" : populate ?? false
            ]
            
            if let ids = moduleIds {
                params["module"] = ids
            }
            
            if let ids = instanceIds {
                params["id"] = ids
            }
            
            if !flags!.contains(GeneralContentFlag.IncludeArchived) {
                params["archived"] = "false"
            }
            
            if let p = page, l = limit {
                params["page"] = p
                params["limit"] = l
            } else {
                params["skip"] = "true"
            }
            
            return Halo.Request(router: Router.GeneralContentInstances(params))
            
    }
    
    /**
    Utility function to parse the JSON coming from the request into an array of General Content instances

    - parameter instances:   Array of dictionaries (JSON) coming directly from the response

    - returns Array of parsed General Content instances
    */
    private func parseGeneralContentInstances(instances: [[String: AnyObject]], includeUnpublished: Bool) -> [GeneralContentInstance] {
        let inst = instances.map({ GeneralContentInstance($0) })
        
        return inst.filter { (instance) -> Bool in
            
            if includeUnpublished {
                return !instance.isRemoved()
            } else {
                return instance.isPublished() && !instance.isRemoved()
            }
            
        }
    }

}