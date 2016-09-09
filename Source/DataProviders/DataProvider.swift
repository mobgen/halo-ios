//
//  DataProvider.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public protocol DataProvider {

    func getModules(completionHandler handler: (Halo.Result<PaginatedModules>) -> Void) -> Void
    func search(searchQuery: Halo.SearchQuery, completionHandler handler: (Halo.Result<PaginatedContentInstances>) -> Void) -> Void

}
