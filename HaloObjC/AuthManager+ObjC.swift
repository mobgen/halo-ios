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
    
    // MARK: Login and registration
    
    @objc(loginWithAuthProfile:stayLoggedIn:success:failure:)
    public func loginObjC(authProfile: AuthProfile, stayLoggedIn: Bool = Manager.auth.stayLoggedIn,
                          success: @escaping (HTTPURLResponse?, User) -> Void,
                          failure: @escaping (HTTPURLResponse?, Error) -> Void) -> Void {
        
        self.login(authProfile: authProfile) { response, result in
            
            switch result {
            case .success(let user, _):
                if let user = user {
                    success(response, user)
                } else {
                    failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user received from server"]))
                }
            case .failure(let error):
                failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: error.description]))
            }
        }
    }
    
    @objc(registerWithAuthProfile:userProfile:success:failure:)
    public func registerObjC(authProfile: AuthProfile, userProfile: UserProfile,
                             success: @escaping (HTTPURLResponse?, UserProfile) -> Void,
                             failure: @escaping (HTTPURLResponse?, Error) -> Void) -> Void {
        
        self.register(authProfile: authProfile, userProfile: userProfile) { response, result in
            
            switch result {
            case .success(let profile, _):
                if let profile = profile {
                    success(response, profile)
                } else {
                    failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user profile received from server"]))
                }
            case .failure(let error):
                failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: error.description]))
            }
        }
        
    }
    
    // MARK: Pocket
    
    @objc(getPocketWithFilter:success:failure:)
    public func getPocketWithSuccess(_ filterReferences: [String]?, success: @escaping (HTTPURLResponse?, Pocket) -> Void,
                                     failure: @escaping (HTTPURLResponse?, Error) -> Void) -> Void {
        
        self.getPocket(filterReferences: filterReferences) { response, result in
            
            switch result {
            case .success(let pocket, _):
                if let pocket = pocket {
                    success(response, pocket)
                } else {
                    failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: "No pocket received from server"]))
                }
            case .failure(let error):
                failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: error.description]))
            }
            
        }
        
    }
    
    @objc(savePocket:withSuccess:failure:)
    public func savePocket(_ pocket: Pocket,
                           success: @escaping (HTTPURLResponse?, Pocket) -> Void,
                           failure: @escaping (HTTPURLResponse?, Error) -> Void) -> Void {
        
        self.savePocket(pocket) { response, result in
            switch result {
            case .success(let pocket, _):
                if let pocket = pocket {
                    success(response, pocket)
                } else {
                    failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: "No pocket received from server"]))
                }
            case .failure(let error):
                failure(response, NSError(domain: "com.mobgen.halo", code: -1, userInfo: [NSLocalizedDescriptionKey: error.description]))
            }
        }
        
    }
    
}
