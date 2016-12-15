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
    func logout(completionHandler handler: ((Bool) -> Void)?) -> Void
}

public extension AuthProvider {
    
    func authenticate(authProfile: AuthProfile, completionHandler handler: @escaping (User?, NSError?) -> Void) {
        let request = Halo.Request<User>(router: Router.loginUser(authProfile.toDictionary()))
        try! request.responseParser(parser: userParser).responseObject { (_, result) in
            switch result {
            case .success(let user, _):
                if let user = user {
                    KeychainHelper.set(user, forKey: AuthManager.Keys.User)
                    LogMessage(message: "Login with Halo successful.", level: .info).print()
                } else {
                    LogMessage(message: "An error happened when trying to login with Halo.", level: .error).print()
                }
                handler(user, nil)
            case .failure(let error):
                LogMessage(message: "An error happened trying to authenticate the user with Halo.", error: error).print()
                handler(nil, error)
            }
        }
    }
    
    func logout(completionHandler handler: ((Bool) -> Void)?) {
        let result = KeychainHelper.remove(forKey: AuthManager.Keys.User)
        handler?(result)
    }
    
    // MARK : Private methods.
    
    private func userParser(_ data: Any?) -> User? {
        if let dict = data as? [String: Any] {
            return User.fromDictionary(dict)
        }
        return nil
    }
    
}

