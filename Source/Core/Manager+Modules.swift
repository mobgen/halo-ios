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
    public func getModules(offlinePolicy: OfflinePolicy? = Manager.core.defaultOfflinePolicy,
        completionHandler handler: ((Halo.Result<[Halo.Module], NSError>) -> Void)?) -> Void {
        
        switch offlinePolicy! {
        case .None:
            Manager.network.getModules().response(completionHandler: { (result) -> Void in
                switch result {
                case .Success(let data as [[String : AnyObject]], let cached):
                    let modules = data.map({ Halo.Module($0) })
                    handler?(.Success(modules, cached))
                case .Failure(let error):
                    handler?(.Failure(error))
                default:
                    break
                }
            })
        case .LoadAndStoreLocalData, .ReturnLocalDataDontLoad:
            Manager.persistence.getModules(fetchFromNetwork: (offlinePolicy == .LoadAndStoreLocalData), completionHandler: handler)
        }
    }

}