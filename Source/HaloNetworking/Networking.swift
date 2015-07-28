//
//  Networking.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire
import Result

/// Module encapsulating all the networking features of the Framework
class Networking {
    
    var token:HaloToken?
    
    let alamofire = Alamofire.Manager.sharedInstance
    
    /**
    Authenticate against the HALO backend using a client id and a client secret
    
    :param: clientId            Client id to be used for authentication
    :param: clientSecret        Client secret to be used for authentication
    :param: completionHandler   Callback where the response from the server can be processed
    */
    func authenticate(clientId: String!, clientSecret: String!, completionHandler handler: (result: Result<HaloToken, NSError>) -> Void) -> Void {
        
        let params = [
            "grant_type" : "client_credentials",
            "client_id" : clientId,
            "client_secret" : clientSecret
        ]
        
        alamofire.request(.POST, HaloURL.OAuth.URL, parameters: params, encoding: .URL).responseJSON { (req, resp:NSHTTPURLResponse?, json, error:NSError?) -> Void in
            
            if let jsonDict = json as? Dictionary<String,AnyObject> {
                
                self.token = HaloToken(dict: jsonDict)
                self.alamofire.session.configuration.HTTPAdditionalHeaders = ["Authorization" : "\(self.token?.tokenType) \(self.token?.token)"]
                handler(result: .Success(self.token!))
                
            } else {
                handler(result: .Failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
        }
    }
    
    /**
    Refresh the OAuth token
    
    :param: clientId        The client id
    :param: clientSecret    The client secret
    :param: refreshToken    The refresh token to be used
    */
    private func refreshToken(clientId: String!, clientSecret: String!, refreshToken: String!) -> Void {
        
        let params = [
            "grant_type" : "refresh_token",
            "client_id" : clientId,
            "client_secret" : clientSecret,
            "refresh_token" : refreshToken
        ]
        
        alamofire.request(.POST, HaloURL.OAuth.URL, parameters: params, encoding: .URL).responseJSON { (req, resp:NSHTTPURLResponse?, json, error:NSError?) -> Void in
            
            if let jsonDict = json as? Dictionary<String,AnyObject> {
                
                self.token = HaloToken(dict: jsonDict)
                self.alamofire.session.configuration.HTTPAdditionalHeaders = ["Authorization" : "\(self.token?.tokenType) \(self.token?.token)"]
                
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    /**
    Get the list of available modules for a given client id/client secret pair
    
    :param: completionHandler   Callback executed when the request has finished
    */
    func getModules(completionHandler handler: (result: Result<[String], NSError>) -> Void) -> Void {
        
        if let _ = self.token {
            
            alamofire.request(.GET, HaloURL.ModulesList.URL, parameters: nil, encoding: .URL).responseJSON(completionHandler: { (req, resp, json, error) -> Void in
                
                if let jsonDict = json as? Dictionary<String,AnyObject> {
                    print(jsonDict)
                    let arr = [String]()
                    handler(result:.Success(arr))
                } else {
                    let error = NSError(domain: "halo.mobgen.com", code: -1, userInfo: nil)
                    handler(result:.Failure(error))
                    print(resp)
                    print(error)
                }
            });
            
        } else {
            authenticate(manager?.clientId, clientSecret: manager?.clientSecret, completionHandler: { (result) -> Void in
                self.getModules(completionHandler: handler)
            })
        }
    }
    
}