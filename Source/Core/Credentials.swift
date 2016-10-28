//
//  Credentials.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 11/01/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

enum CredentialType {
    case app
    case user
}

@objc(HaloCredentials)
open class Credentials: NSObject {

    var username: String = ""
    var password: String = ""
    var type: CredentialType = .app

    public init(username: String, password: String) {
        super.init()
        self.type = .user
        self.username = username
        self.password = password
    }

    public init(clientId: String, clientSecret: String) {
        super.init()
        self.type = .app
        self.username = clientId
        self.password = clientSecret
    }

}
