//
//  HaloToken.swift
//  HaloSDK
//
//  Created by Borja on 28/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

public class HaloToken : NSObject {
    
    public var token:String
    public var refreshToken:String
    public var tokenType:String
    public var expiresIn:NSTimeInterval
    
    init(dict: Dictionary<String,AnyObject>) {
        self.token = dict["access_token"] as! String
        self.refreshToken = dict["refresh_token"] as! String
        self.tokenType = dict["token_type"] as! String
        
        let expire = dict["expires_in"] as! NSNumber
        
        self.expiresIn =  expire.doubleValue/1000
    }
    
}