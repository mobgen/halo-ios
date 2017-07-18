//
//  MockToken.swift
//  Halo
//
//  Created by Miguel López on 27/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import OHHTTPStubs
@testable import Halo

class MockToken : Token {
    
    static let TestAccessToken = "9aCH1pgfgnonimCE7pUxIPOecjw7k7kqvi67PyIG"
    static let TestRefreshToken = "54kBFdhtSQhccyRp6ppZ2CpnCDTJfypWEDMaK5Ot"
    static let TestTokenType = "Bearer"
    static let TestExpiresIn = NSNumber(value: 1478875644)
    
    static let TestDict: [String: Any] = [
        Token.Keys.AccessToken: MockToken.TestAccessToken,
        Token.Keys.RefreshToken: MockToken.TestRefreshToken,
        Token.Keys.TokenType: MockToken.TestTokenType,
        Token.Keys.ExpiresIn: MockToken.TestExpiresIn
    ]
    
    class func createFromJson(_ filePath: String? = OHPathForFileInBundle("token.json", Bundle.init(for: MockToken.classForCoder()))) -> Token? {
        guard
            let filePath = filePath,
            let jsonData = NSData(contentsOfFile: filePath) as Data?,
            let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]),
            let dict = jsonResult as? [String: AnyObject]
        else {
            XCTFail("The creation of fake Token fails.")
            return nil
        }
        
        return Token.fromDictionary(dict)
    }
}
