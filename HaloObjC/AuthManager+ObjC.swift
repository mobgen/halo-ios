//
//  AuthManager+ObjC.swift
//  Halo
//
//  Created by Borja Santos-Díez on 17/01/17.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

import Foundation
import Halo

public extension AuthManager {
    
    @objc(loginWithAuthProfile:stayLoggedIn:completionHandler:)
    public func loginObjC(authProfile: AuthProfile, stayLoggedIn: Bool = Manager.auth.stayLoggedIn, completionHandler handler: @escaping (User?, NSError?) -> Void) -> Void {
        
        self.login(authProfile: authProfile) { (user, error) in
            
            var info: [AnyHashable: String]? = nil
            
            if let error = error {
                info = [NSLocalizedDescriptionKey: error.description]
            }
            
            handler(user, NSError(domain: "com.mobgen.halo", code: -1, userInfo: info))
        }
        
    }
    
    @objc(registerWithAuthProfile:userProfile:completionHandler:)
    public func registerObjC(authProfile: AuthProfile, userProfile: UserProfile, completionHandler handler: @escaping (UserProfile?, NSError?) -> Void) -> Void {
        
        self.register(authProfile: authProfile, userProfile: userProfile) { (profile, error) in
            
            var info: [AnyHashable: String]? = nil
            
            if let error = error {
                info = [NSLocalizedDescriptionKey: error.description]
            }
            
            handler(profile, NSError(domain: "com.mobgen.halo", code: -1, userInfo: info))
            
        }
        
    }
    
}
