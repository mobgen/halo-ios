//
//  HaloToken.swift
//  HaloSDK
//
//  Created by Borja on 28/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


/**
Class holding all the information related to the authentication token
 */
@objc(HaloToken)
open class Token: NSObject, NSCoding {

    struct Keys {
        static let AccessToken = "access_token"
        static let RefreshToken = "refresh_token"
        static let TokenType = "token_type"
        static let ExpiresIn = "expires_in"
    }

    /// Access token
    open var token: String?

    /// Refresh token
    open var refreshToken: String?

    /// Type of the auth token
    open var tokenType: String?

    /// Expiration date of this authentication token
    open var expirationDate: Date?

    override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        token = aDecoder.decodeObject(forKey: Keys.AccessToken) as? String
        refreshToken = aDecoder.decodeObject(forKey: Keys.RefreshToken) as? String
        tokenType = aDecoder.decodeObject(forKey: Keys.TokenType) as? String
        expirationDate = aDecoder.decodeObject(forKey: Keys.ExpiresIn) as? Date
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(token, forKey: Keys.AccessToken)
        aCoder.encode(refreshToken, forKey: Keys.RefreshToken)
        aCoder.encode(tokenType, forKey: Keys.TokenType)
        aCoder.encode(expirationDate, forKey: Keys.ExpiresIn)
    }

    /**
    Initialise a HaloToken from a given dictionary

    - parameter dict: Dictionary containing all the token related information
    */
    public static func fromDictionary(_ dict: [String: Any]) -> Token {

        let token = Token()

        token.token = dict[Keys.AccessToken] as? String
        token.refreshToken = dict[Keys.RefreshToken] as? String
        token.tokenType = dict[Keys.TokenType] as? String

        if let expire = dict[Keys.ExpiresIn] as? NSNumber {
            token.expirationDate = Date().addingTimeInterval(expire.doubleValue/1000)
        }

        return token
    }

    /**
    Utility function to check whether the current token has expired or not

    - returns: Boolean determining whether the token has expired or not
    */
    open func isExpired() -> Bool {
        return expirationDate?.timeIntervalSince(Date()) < 0
    }

    /**
    Utility function to check whether the current token is still valid or not

    - returns: Boolean determining whether the token is still valid or not
    */
    open func isValid() -> Bool {
        return !isExpired()
    }
}
