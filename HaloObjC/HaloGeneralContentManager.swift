//
//  HaloGeneralContentManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Halo

@objc public enum GeneralContentFlags: Int {
    case None, IncludeArchived, IncludeUnpublished, IncludeArchivedAndUnpublished
}

public class HaloGeneralContentManager: NSObject {
 
    static let sharedInstance = HaloGeneralContentManager()
    
    private let content = Halo.Manager.content
    
    private override init() {
        super.init()
    }
    
    @objc
    public func instances(moduleIds moduleIds: [String],
                                    offlinePolicy: OfflinePolicy,
                                    success: (NSHTTPURLResponse?, HaloPaginatedContentInstances) -> Void,
                                    failure: (NSHTTPURLResponse?, NSError) -> Void) -> Void {
        
        var searchOptions = SearchOptions()
        searchOptions.setOfflinePolicy(offlinePolicy)
        
        try! content.getInstances(searchOptions).responseObject { (response, result) in
            switch result {
            case .Success(let data, _):
                if let instances = data {
                    success(response, HaloPaginatedContentInstances(data: instances))
                }
            case .Failure(let error):
                failure(response, error)
            }
        }
    }
    
    @objc
    public func instances(instanceIds instanceIds: [String],
                                      offlinePolicy: OfflinePolicy,
                                      success: (NSHTTPURLResponse?, HaloPaginatedContentInstances) -> Void,
                                      failure: (NSHTTPURLResponse?, NSError) -> Void) -> Void {
        
        var searchOptions = SearchOptions()
        searchOptions.setOfflinePolicy(offlinePolicy)
        
        try! content.getInstances(searchOptions).responseObject { (response, result) in
            switch result {
            case .Success(let data, _):
                if let instances = data {
                    success(response, HaloPaginatedContentInstances(data: instances))
                }
            case .Failure(let error):
                failure(response, error)
            }
        }
        
    }

}