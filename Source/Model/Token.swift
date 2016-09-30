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

    struct Keys {
        static let AccessToken = "access_token"
        static let RefreshToken = "refresh_token"
        static let TokenType = "token_type"
        static let ExpiresIn = "expires_in"
    }

    /// Access token
    public var token: String?

    /// Refresh token
    public var refreshToken: String?

    /// Type of the auth token
    public var tokenType: String?

    /// Expiration date of this authentication token
    public var expirationDate: NSDate?

    private override init() {
        super.init()
    }

    /**
    Initialise a HaloToken from a given dictionary

    - parameter dict: Dictionary containing all the token related information
    */
    public static func fromDictionary(dict dict: [String: AnyObject]) -> Token {

        let token = Token()

        token.token = dict[Keys.AccessToken] as? String
        token.refreshToken = dict[Keys.RefreshToken] as? String
        token.tokenType = dict[Keys.TokenType] as? String

        if let expire = dict[Keys.ExpiresIn] as? NSNumber {
            token.expirationDate = NSDate().dateByAddingTimeInterval(expire.doubleValue/1000)
        }

        return token
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
