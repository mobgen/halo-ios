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
    
    func haloRequest(method: Halo.Method, url: String, var params: [String: AnyObject]?, populate: Bool? = false,
        completionHandler handler: ((Halo.Result<AnyObject, NSError>) -> Void)? = nil) -> Void {
            
            if var p = params {
                p["populate"] = populate
            } else {
                params = ["populate" : populate!]
            }
            
            self.startRequest(request: Router.CustomRequest(method, url, params)) { (request, response, result) in
                handler?(result)
            }
    }
}