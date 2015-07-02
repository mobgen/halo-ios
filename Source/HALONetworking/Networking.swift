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
    
    var tokenType:String?
    var token:String? = "WO62Z1kAKAB9qtxeN9RioMDuYySF1PrgvcIBQ9HM"
    
    let alamofire = Alamofire.Manager.sharedInstance
    let baseUrl = "http://halo.mobgen.com:3000"
    let modulesListUrl = "/api/generalcontent/module/list"
    
    /**
    Authenticate against the HALO backend using a client id and a client secret
    
    :param: clientId            Client id to be used for authentication
    :param: clientSecret        Client secret to be used for authentication
    :param: completionHandler   Callback where the response from the server can be processed
    */
    public func haloAuthenticate(clientId: String!, clientSecret: String!, completionHandler: (result: Result<Dictionary<String,AnyObject>, NSError>) -> Void) -> Void {
        
        let params = [
            "grant_type" : "client_credentials",
            "client_id" : clientId,
            "client_secret" : clientSecret
        ]
        
        alamofire.request(.POST, "\(baseUrl)/api/oauth/token?_1", parameters: params, encoding: .URL).responseJSON { (req, resp:NSHTTPURLResponse?, json, error:NSError?) -> Void in
            
            if resp != nil && resp?.statusCode == 200 {
                
                if let jsonDict = json as? Dictionary<String,AnyObject> {
                
                    self.tokenType = jsonDict["token_type"] as? String
                    //self.token = jsonDict["access_token"] as? String
                    self.alamofire.session.configuration.HTTPAdditionalHeaders = ["Authorization" : "\(self.tokenType!) \(self.token)"]
                    completionHandler(result: Result.Success(Box(jsonDict)))
                } else {
                    
                    completionHandler(result: .Failure(Box(error!)))
                }
            } else {
                completionHandler(result: .Failure(Box(error!)))
            }
        }
    }
    
    public func haloModules(completionHandler handler: (result: Result<[String],NSError>) -> Void) {
        
        if let localToken = self.token {
            
            alamofire.request(.GET, "\(self.baseUrl)\(self.modulesListUrl)", parameters: nil, encoding: .URL).responseJSON { (req:NSURLRequest, resp:NSHTTPURLResponse?, json, error) -> Void in
                
                if resp?.statusCode == 200 {
                    
                    handler(result: .Success(Box([])))
                    
                } else {
                    handler(result: .Failure(Box(error!)))
                    println("Error getting module list")
                }
                
            }
        } else {
            haloAuthenticate(self.manager?.clientId, clientSecret: self.manager?.clientSecret, completionHandler: { (result) -> Void in
                self.haloModules(completionHandler: handler)
            })
        }
    }
    
}