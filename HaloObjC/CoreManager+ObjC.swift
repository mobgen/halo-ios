//
//  HaloCoreManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Halo

extension CoreManager {

    @objc
    public func modules(success: (NSHTTPURLResponse?, PaginatedModules) -> Void,
                        failure: (NSHTTPURLResponse?, NSError) -> Void) -> Void {

        self.getModules { (response, result) in

            switch result {
            case .Success(let data, _):
                if let modules = data {
                    success(response, modules)
                }
            case .Failure(let error):
                failure(response, error)
            }
        }
    }
}
