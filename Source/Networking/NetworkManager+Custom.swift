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
    
    func haloRequest<T>(method: Halo.Method, url: String, params: [String: AnyObject]?,
        completionHandler handler: ((Halo.Result<T, NSError>) -> Void)? = nil) -> Void {

            var req = Halo.Request<T>(path: url).method(method)

            if let p = params {
                req = req.params(p)
            }

            req.response { (request, response, result) -> Void in
                handler?(result)
            }

    }
}