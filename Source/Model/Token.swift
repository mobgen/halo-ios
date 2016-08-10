//
//  HaloToken.swift
//  HaloSDK
//
//  Created by Borja on 28/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/**
Class holding all the information related to the authentication token
 */
@objc(HaloToken)
public class Token: NSObject {

    /// Access token
    public var token: String?

    /// Refresh token
    public var refreshToken: String?

    /// Type of the auth token
    public var tokenType: String?

    /// Expiration date of this authentication token
    public var expirationDate: NSDate?

    /**
    Initialise a HaloToken from a given dictionary

    - parameter dict: Dictionary containing all the token related information
    */
    public init(_ dict: [String: AnyObject]) {
        token = dict["access_token"] as? String
        refreshToken = dict["refresh_token"] as? String
        tokenType = dict["token_type"] as? String

        if let expire = dict["expires_in"] as? NSNumber {
            expirationDate = NSDate().dateByAddingTimeInterval(expire.doubleValue/1000)
        }
    }

    /**
    Utility function to check whether the current token has expired or not

    - returns: Boolean determining whether the token has expired or not
    */
    public func isExpired() -> Bool {
        return expirationDate?.timeIntervalSinceDate(NSDate()) < 0
    }

    /**
    Utility function to check whether the current token is still valid or not

    - returns: Boolean determining whether the token is still valid or not
    */
    public func isValid() -> Bool {
        return !isExpired()
    }
}
