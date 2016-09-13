//
//  GeneralContent.swift
//  HaloSDK
//
//  Created by Borja on 31/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/**
 Access point to the General Content. This class will provide methods to obtain the data stored as general content.
 */
public struct ContentManager: HaloManager {

    public var defaultLocale: Halo.Locale?

    init() {}

    public func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {

    }

    // MARK: Get instances

    public func search(searchQuery: Halo.SearchQuery, completionHandler handler: (NSHTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void {
        Manager.core.dataProvider.search(searchQuery, completionHandler: handler)
    }

}
