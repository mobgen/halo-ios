//
//  NetworkManager+GeneralContent.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 05/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

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
        flags: GeneralContentFlag? = []) -> Halo.Request {
            
            let req = self.generalContentInstancesRequest(moduleIds: moduleIds, instanceIds: nil, flags: flags)
            
//            req.responseParser { data in
//                switch data {
//                case let data as [String : AnyObject]:
//                    // Paginated result
//                    return self.parseGeneralContentInstances(data["items"] as! [[String:AnyObject]], flags: flags ?? [])
//                    
//                    // Get pagination info
//                    //let paginationInfo = data["pagination"] as! [String: AnyObject]
//                    //let count = paginationInfo["count"] as! Int
//                case let data as [[String : AnyObject]]:
//                    return self.parseGeneralContentInstances(data, flags: flags ?? [])
//                default:
//                    return []
//                }
//            }

            return req
    }
    
    func generalContentInstance(instanceId: String,
        populate: Bool? = false) -> Halo.Request {
        
        let params: [String: AnyObject] = ["populate" : populate!]
        
        let req = Halo.Request(router: Router.GeneralContentInstance(instanceId, params))
            
//        req.responseParser { data in
//            switch data {
//            case let data as [String:AnyObject]:
//                return GeneralContentInstance(data)
//            default:
//                // TODO: Change it!
//                return GeneralContentInstance([:])
//            }
//        }

        return req
            
    }
    
    func generalContentInstances(instanceIds instanceIds: [String],
        flags: GeneralContentFlag? = [],
        populate: Bool? = false) -> Halo.Request {
            
            let req = self.generalContentInstancesRequest(moduleIds: nil, instanceIds: instanceIds, flags: flags)
            
//            req.responseParser { data in
//                
//                switch data {
//                case let data as [[String: AnyObject]]:
//                    return self.parseGeneralContentInstances(data, flags: flags ?? [])
//                default:
//                    return []
//                }
//            }

            return req
    }

    private func generalContentInstancesRequest(moduleIds moduleIds: [String]?,
        instanceIds: [String]?,
        flags: GeneralContentFlag? = []) -> Halo.Request {

            var params: [String : AnyObject] = [:]

            if let ids = moduleIds {
                params["module"] = ids
            }
            
            if let ids = instanceIds {
                params["id"] = ids
            }

            if !flags!.contains(GeneralContentFlag.IncludeArchived) {
                params["archived"] = "false"
            }

            return Halo.Request(router: Router.GeneralContentInstances(params))
    }
    
    /**
    Utility function to parse the JSON coming from the request into an array of General Content instances

    - parameter instances:   Array of dictionaries (JSON) coming directly from the response

    - returns Array of parsed General Content instances
    */
    private func parseGeneralContentInstances(instances: [[String: AnyObject]], flags: GeneralContentFlag) -> [GeneralContentInstance] {

        let inst = instances.map({ GeneralContentInstance($0) })
        
        return inst.filter { (instance) -> Bool in
            
            if flags.contains(.IncludeUnpublished) {
                return !instance.isRemoved()
            } else {
                return instance.isPublished() && !instance.isRemoved()
            }
            
        }
    }

}