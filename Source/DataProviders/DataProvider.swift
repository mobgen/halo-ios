//
//  DataProvider.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public protocol DataProvider {

    func getModules(completionHandler handler: (NSHTTPURLResponse?, Halo.Result<PaginatedModules?>) -> Void) -> Void
    func search(query query: Halo.SearchQuery, completionHandler handler: (NSHTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void

}
