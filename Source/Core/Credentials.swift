//
//  Credentials.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 11/01/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

enum CredentialType {
    case App
    case User
}

@objc(HaloCredentials)
public class Credentials: NSObject {

    var username: String = ""
    var password: String = ""
    var type: CredentialType = .App

    public init(username: String, password: String) {
        super.init()
        self.type = .User
        self.username = username
        self.password = password
    }

    public init(clientId: String, clientSecret: String) {
        super.init()
        self.type = .App
        self.username = clientId
        self.password = clientSecret
    }

}
