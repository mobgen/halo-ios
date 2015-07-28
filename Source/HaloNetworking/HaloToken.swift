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
    public var expirationDate:NSDate
    
    init(dict: Dictionary<String,AnyObject>) {
        token = dict["access_token"] as! String
        refreshToken = dict["refresh_token"] as! String
        tokenType = dict["token_type"] as! String
        
        let expire = dict["expires_in"] as! NSNumber
        
        expirationDate = NSDate().dateByAddingTimeInterval(expire.doubleValue/1000)
    }
    
    public func isExpired() -> Bool {
        return expirationDate.timeIntervalSinceDate(NSDate()) < 0
    }
    
    public func isValid() -> Bool {
        return !isExpired()
    }
}