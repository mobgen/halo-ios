//
//  TokenSpec.swift
//  Halo
//
//  Created by Miguel López on 27/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class TokenSpec : BaseSpec {
    
    override func spec() {
        super.spec()
        
        describe("A Token") {
            var token: Token!
            
            describe("its constructor method") {
                context("with a NSCoder") {
                    var tokenRestored: Token?
                    
                    beforeEach {
                        // Save to temp file.
                        let path = NSTemporaryDirectory()
                        let locToSave = path.appending("testToken")
                        token = MockToken.createFromJson()
                        NSKeyedArchiver.archiveRootObject(token, toFile: locToSave)
                        tokenRestored = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? Token
                    }
                    
                    it("works") {
                        expect(tokenRestored).toNot(beNil())
                        expect(tokenRestored!.token).to(equal(MockToken.TestAccessToken))
                        expect(tokenRestored!.refreshToken).to(equal(MockToken.TestRefreshToken))
                        expect(tokenRestored!.tokenType).to(equal(MockToken.TestTokenType))
                        expect(tokenRestored!.expirationDate).to(beLessThan(Date().addingTimeInterval(MockToken.TestExpiresIn.doubleValue/1000)))
                    }
                }
            }
        }
    }
    
}
