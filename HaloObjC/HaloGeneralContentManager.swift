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
    
    private let generalContent = Halo.Manager.generalContent
    
    private override init() {
        super.init()
    }
    
    @objc
    public func instances(moduleIds moduleIds: [String],
        offlinePolicy: OfflinePolicy,
        flags: GeneralContentFlags) -> HaloRequest {
            
            let flagOptions: GeneralContentFlag
            
            switch flags {
            case .None: flagOptions = []
            case .IncludeArchived: flagOptions = [.IncludeArchived]
            case .IncludeUnpublished: flagOptions = [.IncludeUnpublished]
            case .IncludeArchivedAndUnpublished: flagOptions = [.IncludeArchived, .IncludeUnpublished]
            }
            
            return HaloRequest(request: generalContent.getInstances(moduleIds: moduleIds, offlinePolicy: offlinePolicy, flags: flagOptions))
    }
    
    @objc
    public func instances(instanceIds instanceIds: [String],
        offlinePolicy: OfflinePolicy,
        flags: GeneralContentFlags) -> HaloRequest {
            
            let flagOptions: GeneralContentFlag
            
            switch flags {
            case .None: flagOptions = []
            case .IncludeArchived: flagOptions = [.IncludeArchived]
            case .IncludeUnpublished: flagOptions = [.IncludeUnpublished]
            case .IncludeArchivedAndUnpublished: flagOptions = [.IncludeArchived, .IncludeUnpublished]
            }
            
            return HaloRequest(request: generalContent.getInstances(instanceIds: instanceIds, offlinePolicy: offlinePolicy, flags: flagOptions))
            
    }
    
    @objc
    public func singleInstance(instanceId instanceId: String,
        offlinePolicy: OfflinePolicy) -> HaloRequest {
            return HaloRequest(request: generalContent.getSingleInstance(instanceId: instanceId, offlinePolicy: offlinePolicy))
    }
}