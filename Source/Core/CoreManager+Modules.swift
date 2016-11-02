//
//  Manager+Modules.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 11/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

extension CoreManager {

    /**
     Get a list of the existing modules for the provided client credentials

     - parameter offlinePolicy: Offline policy to be considered when retrieving data
     */
    public func getModules(completionHandler handler: @escaping (HTTPURLResponse?, Result<PaginatedModules?>) -> Void) -> Void {
        return dataProvider.getModules(completionHandler: handler)
    }

}
