//
//  Manager+Modules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 11/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import RealmSwift

extension CoreManager {
 
    /**
     Get a list of the existing modules for the provided client credentials
     
     - parameter offlinePolicy: Offline policy to be considered when retrieving data
     - parameter completionHandler:  Closure to be executed when the request has finished
     */
    public func getModules(offlinePolicy: OfflinePolicy? = Manager.core.defaultOfflinePolicy) -> Halo.Request {
        
        switch offlinePolicy! {
        case .None:
            
            return Manager.network.getModules()
            
//            return request.responseParser({ (data) -> [Module] in
//                switch data {
//                case let d as [[String : AnyObject]]:
//                    return d.map({ Halo.Module($0) })
//                case let d as [String : AnyObject]:
//                    let items = d["items"] as! [[String : AnyObject]]
//                    return items.map({ Halo.Module($0) })
//                default:
//                    return []
//                }
//            })
            
        case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
            // TODO: Change for the real call
            return Manager.network.getModules()
            //Manager.persistence.getModules(fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: handler)
        }
    }

}