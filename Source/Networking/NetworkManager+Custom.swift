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
    
    func haloRequest(method: Alamofire.Method, url: String, params: [String: AnyObject]?,
        completionHandler handler: (Alamofire.Result<AnyObject, NSError>) -> Void) -> Void {
        
        self.startRequest(Router.CustomRequest(method, url, params)) { (request, response, result) in
            handler(result)
        }
        
    }
    
}