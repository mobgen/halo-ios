//
//  HaloToken.swift
//  HaloSDK
//
//  Created by Borja on 28/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

class HaloToken : NSObject {
    
    // 
    var token:String
    var refreshToken:String
    var tokenType:String
    var expiresIn:NSTimeInterval
    
    init(dict: Dictionary<String,AnyObject>) {
        self.token = dict["access_token"] as! String
        self.refreshToken = dict["refresh_token"] as! String
        self.tokenType = dict["token_type"] as! String
        
        let expire = dict["expires_in"] as! NSNumber
        
        self.expiresIn =  expire.doubleValue/100
    }
    
}