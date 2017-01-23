//
//  AuthProfileSpec.swift
//  Halo
//
//  Created by Miguel López on 22/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class AuthProfileSpec: BaseSpec {
    
    static let TestToken = "testtoken"
    static let TestNetwork = Network.Facebook
    static let TestDeviceId = "testdeviceid"
    
    static let TestEmail = "test@mobgen.com"
    static let TestPassword = "testpassword"
    
    override func spec() {
        
        describe("an AuthProfile") {
            var authProfile: AuthProfile!
            
            beforeEach {
                authProfile = AuthProfile(token: AuthProfileSpec.TestToken, network: AuthProfileSpec.TestNetwork, deviceId: AuthProfileSpec.TestDeviceId)
            }
            
            describe("its constructor method") {
                context("using a social network") {
                    it("works") {
                        expect(authProfile).toNot(beNil())
                        expect(authProfile.token).to(equal(AuthProfileSpec.TestToken))
                        expect(authProfile.network.description).to(equal(AuthProfileSpec.TestNetwork.description))
                        expect(authProfile.deviceId).to(equal(AuthProfileSpec.TestDeviceId))
                    }
                }
                
                context("using a NSCoder") {
                    var authProfileRestored: AuthProfile?
                    
                    beforeEach {
                        let path = NSTemporaryDirectory()
                        let locToSave = path.appending("testAuthProfile")
                        NSKeyedArchiver.archiveRootObject(authProfile, toFile: locToSave)
                        authProfileRestored = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? AuthProfile
                    }
                    
                    it("works") {
                        expect(authProfileRestored).toNot(beNil())
                        expect(authProfileRestored!.token).to(equal(AuthProfileSpec.TestToken))
                        expect(authProfileRestored!.network.description).to(equal(AuthProfileSpec.TestNetwork.description))
                        expect(authProfileRestored!.deviceId).to(equal(AuthProfileSpec.TestDeviceId))
                    }
                }
            }
            
            describe("its toDictionary method") {
                var dict: [String: String]?
                beforeEach {
                    authProfile.email = AuthProfileSpec.TestEmail
                    authProfile.password = AuthProfileSpec.TestPassword
                    
                    dict = authProfile.toDictionary()
                }
                
                it("works") {
                    expect(dict).toNot(beNil())
                    expect(dict![AuthProfile.Keys.DeviceId]).to(equal(AuthProfileSpec.TestDeviceId))
                    expect(dict![AuthProfile.Keys.Network]?.description).to(equal(AuthProfileSpec.TestNetwork.description))
                    expect(dict![AuthProfile.Keys.Email]).to(equal(AuthProfileSpec.TestEmail))
                    expect(dict![AuthProfile.Keys.Password]).to(equal(AuthProfileSpec.TestPassword))
                    expect(dict![AuthProfile.Keys.Token]).to(equal(AuthProfileSpec.TestToken))
                }
            }
        }
    }
}
