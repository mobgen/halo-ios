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
        offlinePolicy: OfflinePolicy) -> HaloRequest {
            
            var searchOptions = SearchOptions()
            searchOptions.setOfflinePolicy(offlinePolicy)
        
            return HaloRequest(request: content.getInstances(searchOptions))
    }
    
    @objc
    public func instances(instanceIds instanceIds: [String],
                          offlinePolicy: OfflinePolicy) -> HaloRequest {
        
        
        var searchOptions = SearchOptions()
        searchOptions.setOfflinePolicy(offlinePolicy)
        
        return HaloRequest(request: content.getInstances(searchOptions))
        
    }

}