//
//  Manager+Modules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 11/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

extension Manager {
 
    /**
     Get a list of the existing modules for the provided client credentials
     
     - parameter completionHandler:  Closure to be executed when the request has finished
     */
    public func getModules(offlinePolicy: OfflinePolicy = .LoadAndStoreLocalData, completionHandler handler: (Alamofire.Result<[Halo.Module], NSError>, Bool) -> Void) -> Void {
        
        switch offlinePolicy {
        case .None:
            self.net.getModules(fetchFromNetwork: true, completionHandler: handler)
        case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
            self.persist.getModules(fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: handler)
        }
    }
    
}