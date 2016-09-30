//
//  HaloGeneralContentManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Halo

@objc
public enum ContentFlags: Int {
    case None, IncludeArchived, IncludeUnpublished, IncludeArchivedAndUnpublished
}

extension ContentManager {
    
    @objc(searchWithQuery:success:failure:)
    public func search(query query: Halo.SearchQuery,
                             success: (NSHTTPURLResponse?, PaginatedContentInstances) -> Void,
                             failure: (NSHTTPURLResponse?, NSError) -> Void) -> Void {
        Manager.core.dataProvider.search(query: query) { (response, result) in
            switch result {
            case .Success(let data, _):
                if let instances = data {
                    success(response, instances)
                }
            case .Failure(let error):
                failure(response, error)
            }
        }
    }
    
}
