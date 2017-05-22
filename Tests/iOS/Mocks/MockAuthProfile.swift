//
//  MockAuthProfile.swift
//  Halo
//
//  Created by Miguel López on 20/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
@testable import Halo

class MockAuthProfile : AuthProfile {
    
    override func storeProfile(env: HaloEnvironment = Manager.core.environment) {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(encodedObject, forKey: "\(CoreConstants.keychainUserAuthKey)-\(env.description)")
        UserDefaults.standard.synchronize()
    }
    
    override class func loadProfile(env: HaloEnvironment = Manager.core.environment) -> AuthProfile? {
        if let data = UserDefaults.standard.data(forKey: "\(CoreConstants.keychainUserAuthKey)-\(env.description)") {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? AuthProfile
        }
        
        return nil
    }
    
    override class func removeProfile(env: HaloEnvironment = Manager.core.environment) -> Bool {
        UserDefaults.standard.set(nil, forKey: "\(CoreConstants.keychainUserAuthKey)-\(env.description)")
        UserDefaults.standard.synchronize()
        return true
    }
    
}
