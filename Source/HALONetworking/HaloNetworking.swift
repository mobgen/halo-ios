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
@objc
public class HaloNetworking: HaloModule {
    
    var tokenType:String?
    var token:String?
    
    let alamofire = Alamofire.Manager.sharedInstance
    
    /**
    Authenticate against the HALO backend using a client id and a client secret
    
    :param: clientId            Client id to be used for authentication
    :param: clientSecret        Client secret to be used for authentication
    :param: completionHandler   Callback where the response from the server can be processed
    */
    public func haloAuthenticate(clientId: String!, clientSecret: String!, completionHandler handler: (result: HaloResult<NSDictionary, NSError>) -> Void) -> Void {
        
        let params = [
            "grant_type" : "client_credentials",
            "client_id" : clientId,
            "client_secret" : clientSecret
        ]
        
        alamofire.request(.POST, HaloURL.OAuth.URL, parameters: params, encoding: .URL).responseJSON { (req, resp:NSHTTPURLResponse?, json, error:NSError?) -> Void in
            
            if resp != nil && resp?.statusCode == 200 {
                
                if let jsonDict = json as? NSDictionary {
                
                    self.tokenType = jsonDict["token_type"] as? String
                    self.token = jsonDict["access_token"] as? String
                    self.alamofire.session.configuration.HTTPAdditionalHeaders = ["Authorization" : "\(self.tokenType!) \(self.token)"]
                    
                    handler(result: .Success(Box(jsonDict)))
                } else {
                    handler(result: .Failure(Box(NSError())))
                }
            } else {
                handler(result: .Failure(Box(NSError())))
            }
        }
    }
    
    /**
    Get the list of available modules for a given client id/client secret pair
    
    :param: completionHandler   Callback executed when the request has finished
    */
    public func haloModules(completionHandler handler: (result: HaloResult<[String], NSError>) -> Void) -> Void {
        
        if let localToken = self.token {
            
            alamofire.request(.GET, HaloURL.ModulesList.URL, parameters: nil, encoding: .URL).responseJSON { (req:NSURLRequest, resp:NSHTTPURLResponse?, json, error) -> Void in
                
                if resp?.statusCode == 200 {
                    let arr = [String]()
                    handler(result:.Success(Box(arr)))
                } else {
                    let error = NSError(domain: "halo.mobgen.com", code: -1, userInfo: nil)
                    handler(result:.Failure(Box(error)))
                    println(resp)
                    println(error)
                }
                
            }
        } else {
            haloAuthenticate(manager?.clientId, clientSecret: manager?.clientSecret, completionHandler: { (result) -> Void in
                self.haloModules(completionHandler: handler)
            })
        }
    }
    
}