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

    // https://developer.apple.com/documentation/xcode_release_notes/xcode_10_2_release_notes/swift_5_release_notes_for_xcode_10_2?language=objc
    open override var hash: Int {
        return "\(username):\(password)".hashValue
    }
    
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
