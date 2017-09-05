//
//  AuthProvider.swift
//  Halo
//
//  Created by Miguel López on 15/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public protocol AuthProvider {
    
    func authenticate(authProfile: AuthProfile, completionHandler handler: @escaping (HTTPURLResponse?, Result<User?>) -> Void) -> Void
    func logout()
}

public extension AuthProvider {
    
    func authenticate(authProfile: AuthProfile, completionHandler handler: @escaping (HTTPURLResponse?, Result<User?>) -> Void) {
        Manager.auth.login(authProfile: authProfile, completionHandler: handler)
    }
    
}

