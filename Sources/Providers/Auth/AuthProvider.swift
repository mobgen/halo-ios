//
//  AuthProvider.swift
//  Halo
//
//  Created by Miguel López on 15/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public protocol AuthProvider {
    
    func authenticate(authProfile: AuthProfile, completionHandler handler: @escaping (User?, NSError?) -> Void) -> Void
    func logout()
}

public extension AuthProvider {
    
    func authenticate(authProfile: AuthProfile, completionHandler handler: @escaping (User?, NSError?) -> Void) {
        Manager.auth.login(authProfile: authProfile, completionHandler: handler)
    }
    
    // MARK : Private methods.
    
    private func userParser(_ data: Any?) -> User? {
        if let dict = data as? [String: Any] {
            return User.fromDictionary(dict)
        }
        return nil
    }
    
}

