//
//  SocialManager.swift
//  HaloSocial
//
//  Created by Borja Santos-Díez on 18/11/16.
//  Copyright © 2016 Mobgen Technology. All rights reserved.
//

import Foundation

@objc
public protocol AuthManagerObserver {
    func userDidLogIn(_ user: User)
    func userDidLogOut()
}

@objc(HaloAuthManager)
public class AuthManager: NSObject, HaloManager {
    
    public var stayLoggedIn: Bool = false
    public var currentUser: User?
    fileprivate var observers: [AuthManagerObserver] = []
    
    fileprivate override init() {
        super.init()
    }
    
    @objc(startup:completionHandler:)
    public func startup(_ app: UIApplication, completionHandler handler: ((Bool) -> Void)?) -> Void {
        
    }
    
    public func addObserver(_ observer: AuthManagerObserver) -> Void {
        observers.append(observer)
    }
    
    public func removeObserver(_ observer: AuthManagerObserver) -> Void {
        if let idx = observers.index(where: { $0 === observer }) {
            observers.remove(at: idx)
        }
    }
    
    /**
     Call this method to start the login with Halo.
     
     - parameter authProfile:       AuthProfile with email, password, deviceId and network.
     - parameter completionHandler: Closure to be called after completion
     */
    public func login(authProfile: AuthProfile,
                      stayLoggedIn: Bool = Manager.auth.stayLoggedIn,
                      completionHandler handler: @escaping (HTTPURLResponse?, Result<User?>) -> Void) -> Void {
        
        let request = Halo.Request<User>(Router.loginUser(authProfile.toDictionary()), bypassReadiness: true, checkUnauthorised: false)
        
        do {
            
            try request.responseParser(userParser).responseObject { response, result in
                
                switch result {
                case .success(let user, _):
                    self.currentUser = user
                    
                    guard
                        let user = user
                        else {
                            let e: HaloError = .loginError("No user returned from server")
                            Manager.core.logMessage(e.description, level: .error)
                            handler(response, .failure(e))
                            return
                    }
                    
                    if stayLoggedIn {
                        authProfile.storeProfile()
                    }
                    
                    Manager.core.logMessage("Login with Halo successful.", level: .info)
                    Manager.core.defaultAuthenticationMode = .appPlus
                    
                    // Notify observers
                    self.observers.forEach { $0.userDidLogIn(user) }
                    
                    handler(response, .success(user, false))
                    
                case .failure(let error):
                    let loginError = HaloError.loginError(error.description)
                    
                    Manager.core.logMessage(loginError.description, level: .error)
                    handler(response, .failure(loginError))
                }
            }
        } catch {
            let haloError = HaloError.loginError(error.localizedDescription)
            
            Manager.core.logMessage(haloError.description, level: .error)
            handler(nil, .failure(haloError))
        }
    }
    
    @objc(logout:)
    public func logout(_ handler: @escaping (Bool) -> Void) -> Void {
        // If user not logged in, you can't logout.
        guard
            let _ = self.currentUser
            else {
                handler(false)
                return
        }
        
        var result: Bool = true
        
        Manager.core.addons.forEach { addon in
            if let socialProviderAddon = addon as? AuthProvider {
                socialProviderAddon.logout()
            }
        }
        
        if let _ = AuthProfile.loadProfile() {
            if AuthProfile.removeProfile() {
                self.currentUser = nil
            } else {
                result = false
            }
        } else {
            self.currentUser = nil
        }
        
        Manager.core.defaultAuthenticationMode = .app
        
        // Notify observers
        self.observers.forEach { $0.userDidLogOut() }
        
        handler(result)
    }
    
    /**
     Call this method to start the registration with Halo.
     
     - parameter authProfile:       AuthProfile with email, password, deviceId and network.
     - parameter userProfile:       UserProfile with at least email, name and surname.
     - parameter completionHandler: Closure to be called after completion
     */
    public func register(authProfile: AuthProfile,
                         userProfile: UserProfile,
                         completionHandler handler: @escaping (HTTPURLResponse?, Result<UserProfile?>) -> Void) -> Void {
        
        let request = Halo.Request<UserProfile>(Router.registerUser(["auth": authProfile.toDictionary(), "profile": userProfile.toDictionary()]))
        
        do {
            
            try request.responseParser(userProfileParser).responseObject { response, result in
                switch result {
                case .success(let userProfile, _):
                    Manager.core.logMessage("Registration with Halo successful.", level: .info)
                    handler(response, .success(userProfile, false))
                case .failure(let error):
                    let haloError = HaloError.registrationError(error.localizedDescription)
                    
                    Manager.core.logMessage(haloError.description, level: .error)
                    handler(response, .failure(error))
                }
            }
        } catch {
            let haloError = HaloError.registrationError(error.localizedDescription)
            
            Manager.core.logMessage(haloError.description, level: .error)
            handler(nil, .failure(haloError))
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
