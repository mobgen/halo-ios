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
    func generalContentInstances(moduleId: String, flags: GeneralContentFlag, completionHandler handler: (Alamofire.Result<[GeneralContentInstance]>) -> Void) -> Void {

        var params = ["module" : moduleId]
        
        if !flags.contains(GeneralContentFlag.IncludeArchived) {
            params["archived"] = "false"
        }
        
        let unpublished = flags.contains(GeneralContentFlag.IncludeUnpublished)
        
        self.startRequest(Router.GeneralContentInstances(params)) { [weak self] (req, resp, result) -> Void in

            if let response = resp {
                if response.statusCode == 200 {

                    if let strongSelf = self {
                        switch result {
                        case .Success(let data):
                            let arr = strongSelf.parseGeneralContentInstances(data as! [[String: AnyObject]], includeUnpublished: unpublished)
                            handler(.Success(arr))
                        case .Failure(let data, let error):
                            handler(.Failure(data, error))
                        }
                    }
                } else {
                    handler(.Failure(nil, NSError(domain: "com.mobgen.halo", code: 0, userInfo: [NSLocalizedDescriptionKey : "Error retrieving module instances"])))
                }
            } else {
                handler(.Failure(nil, NSError(domain: "com.mobgen.halo", code: 0, userInfo: [NSLocalizedDescriptionKey : "No response received from server"])))
            }
        }
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
                return true
            } else {
                if let published = instance.publishedAt {
                    return published < NSDate()
                } else {
                    return false
                }
            }
            
        }
    }

}