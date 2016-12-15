//
//  SocialManager.swift
//  HaloSocial
//
//  Created by Borja Santos-Díez on 18/11/16.
//  Copyright © 2016 Mobgen Technology. All rights reserved.
//

import Foundation

@objc(HaloAuthManager)
public class AuthManager: NSObject, HaloManager {
    
    @objc(startup:)
    public func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {
        
    }
    
    /**
     Call this method to start the login with Halo.
     
     - parameter authProfile:       AuthProfile with email, password, deviceId and network.
     - parameter completionHandler: Closure to be called after completion
     */
    @objc(loginWithAuthProfile:completionHandler:)
    public func login(authProfile: AuthProfile, completionHandler handler: @escaping (User?, NSError?) -> Void) -> Void {
        
        let request = Halo.Request<User>(router: Router.loginUser(authProfile.toDictionary()))
        
        _ = try? request.responseParser(parser: userParser).responseObject { (_, result) in
            switch (result) {
            case .success(let user, _):
                
                LogMessage(message: "Login with Halo successful.", level: .info).print()
                handler(user, nil)
            case .failure(let error):
                LogMessage(message: "An error happened when trying to login with Halo.", error: error).print()
                handler(nil, error)
            }
        }
    }
    
    /**
     Call this method to start the registration with Halo.
     
     - parameter authProfile:       AuthProfile with email, password, deviceId and network.
     - parameter userProfile:       UserProfile with at least email, name and surname.
     - parameter completionHandler: Closure to be called after completion
     */
    @objc(registerWithAuthProfile:userProfile:completionHandler:)
    public func register(authProfile: AuthProfile, userProfile: UserProfile, completionHandler handler: @escaping (UserProfile?, NSError?) -> Void) -> Void {
        
        let request = Halo.Request<UserProfile>(router: Router.registerUser(["auth": authProfile.toDictionary(), "profile": userProfile.toDictionary()]))
        
        _ = try? request.responseParser(parser: userProfileParser).responseObject { (_, result) in
            switch result {
            case .success(let userProfile, _):
                LogMessage(message: "Registration with Halo successful.", level: .info).print()
                handler(userProfile, nil)
            case .failure(let error):
                LogMessage(message: "An error happened when trying to register a new user with Halo .", error: error).print()
                handler(nil, error)
            }
        }
    }
    
    // MARK : Private methods.
    
    private func userParser(_ data: Any?) -> User? {
        if let dict = data as? [String: Any] {
            return User.fromDictionary(dict)
        }
        return nil
    }
    
    private func userProfileParser(_ data: Any?) -> UserProfile? {
        if let dict = data as? [String: Any] {
            return UserProfile.fromDictionary(dict)
        }
        return nil
    }
    
}

public extension Manager {
    
    public static let auth: AuthManager = {
        return AuthManager()
    }()
    
}
