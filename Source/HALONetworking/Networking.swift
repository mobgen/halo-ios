//
//  Networking.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import HALOCore
import Alamofire

/// Module encapsulating all the networking features of the Framework
@objc(Networking)
public class Networking: Module {
    
    let manager = Alamofire.Manager.sharedInstance
    let baseUrl = "http://52.28.152.145:3000"
    
    /**
    Authenticate against the HALO backend using a client id and a client secret
    
    :param: clientId            Client id to be used for authentication
    :param: clientSecret        Client secret to be used for authentication
    :param: completionHandler   Callback where the response from the server can be processed
    */
    public func haloAuthenticate(clientId: String!, clientSecret: String!, completionHandler: (responseObject: NSDictionary?, err: NSError?) -> Void) -> Void {
        
        let params = [
            "grant_type" : "client_credentials",
            "client_id" : clientId,
            "client_secret" : clientSecret
        ]
        
        manager.request(.POST, "\(baseUrl)/api/oauth/token?_1", parameters: params, encoding: .URL).responseJSON { (req, resp:NSHTTPURLResponse?, json, error) -> Void in
            
            if resp?.statusCode == 200 {
                completionHandler(responseObject: json as? NSDictionary, err: error)
            } else {
                completionHandler(responseObject: nil, err: nil)
            }
        }
    }
}