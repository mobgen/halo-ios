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
@objc(HaloNetworking)
public class HaloNetworking: HaloModule {
    
    var tokenType:String?
    var token:String? = "WO62Z1kAKAB9qtxeN9RioMDuYySF1PrgvcIBQ9HM"
    
    let alamofire = Alamofire.Manager.sharedInstance
    
    public typealias HaloSuccessHandler = (responseObject: NSDictionary) -> Void
    public typealias HaloFailureHandler = (error: NSError) -> Void
    
    /**
    Authenticate against the HALO backend using a client id and a client secret
    
    :param: clientId            Client id to be used for authentication
    :param: clientSecret        Client secret to be used for authentication
    :param: completionHandler   Callback where the response from the server can be processed
    */
    public func haloAuthenticate(clientId: String!, clientSecret: String!, onSuccess: HaloSuccessHandler, onFailure: HaloFailureHandler) -> Void {
        
        let params = [
            "grant_type" : "client_credentials",
            "client_id" : clientId,
            "client_secret" : clientSecret
        ]
        
        alamofire.request(.POST, HaloURL.OAuth.URL, parameters: params, encoding: .URL).responseJSON { (req, resp:NSHTTPURLResponse?, json, error:NSError?) -> Void in
            
            if resp != nil && resp?.statusCode == 200 {
                
                if let jsonDict = json as? Dictionary<String,AnyObject> {
                
                    self.tokenType = jsonDict["token_type"] as? String
                    //self.token = jsonDict["access_token"] as? String
                    self.alamofire.session.configuration.HTTPAdditionalHeaders = ["Authorization" : "\(self.tokenType!) \(self.token)"]
                    onSuccess(responseObject: jsonDict)
                } else {
                    onFailure(error: NSError())
                }
            } else {
                onFailure(error: error!)
            }
        }
    }
    
    public func haloModules(onSuccess: HaloSuccessHandler, onFailure: HaloFailureHandler) -> Void {
        
        if let localToken = self.token {
            
            alamofire.request(.GET, HaloURL.ModulesList.URL, parameters: nil, encoding: .URL).responseJSON { (req:NSURLRequest, resp:NSHTTPURLResponse?, json, error) -> Void in
                
                if resp?.statusCode == 200 {
                    
                    let arr = [String]()
                    
                    onSuccess(responseObject: json as! NSDictionary)
                    
                } else {
                    onFailure(error: NSError())
                    println("Error getting module list")
                }
                
            }
        } else {
            haloAuthenticate(manager?.clientId, clientSecret: manager?.clientSecret, onSuccess: { (responseObject) -> Void in
                self.haloModules(onSuccess, onFailure: onFailure)
            }, onFailure: { (error) -> Void in
                println("Error authenticating")
            })
        }
    }
    
}