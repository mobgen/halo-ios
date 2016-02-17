//
//  NetworkManager+Custom.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 28/10/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

extension NetworkManager {
    
    func haloRequest(method: Halo.Method,
        url: String,
        params: [String: AnyObject]? = nil,
        completionHandler handler: ((Halo.Result<AnyObject, NSError>) -> Void)? = nil) -> Void {

            var req = Halo.Request(path: url).method(method)

            if let p = params {
                req = req.params(p)
            }

            req.response { result in
                handler?(result)
            }

    }
}