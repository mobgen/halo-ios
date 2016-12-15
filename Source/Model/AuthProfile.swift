//
//  AuthProfile.swift
//  HaloSocial
//
//  Created by Borja Santos-Díez on 17/11/16.
//  Copyright © 2016 Mobgen Technology. All rights reserved.
//

import Foundation

public enum Network: Int {
    case Halo, Facebook, Google
    
    var description: String {
        switch self {
        case .Halo:
            return "halo"
        case .Facebook:
            return "facebook"
        case .Google:
            return "google"
        }
    }
}

@objc(HaloAuthProfile)
public class AuthProfile: NSObject {
    
    struct Keys {
        static let DeviceId = "deviceId"
        static let Network = "network"
        static let Email = "email"
        static let Password = "password"
        static let Token = "token"
    }
    
    var deviceId: String
    var network: String
    var email: String?
    var password: String?
    var token: String?
    
    public override var debugDescription: String {
        return "[AuthProfile] Email: \(email) | Password: \(password) | DeviceId: \(deviceId)"
            + "| Token \(token) | Network: \(network)"
    }
    
    /**
     *  Constructor for AuthProfile with Halo.
     *
     *  @param  email       String  Email.
     *  @param  password    String  Password.
     *  @param  deviceId    String  DeviceId.
     **/
    public init(email: String, password: String, deviceId: String) {
        self.email = email
        self.password = password
        self.deviceId = deviceId
        self.network = Network.Halo.description
        super.init()
    }
    
    /**
     *  Constructor for AuthProfile with social network.
     *
     *  @param  token       String  Token from social network.
     *  @param  network     String  Social network to use.
     *  @param  deviceId    String  DeviceId.
     **/
    public init(token: String, network: Network, deviceId: String) {
        self.token = token
        self.network = network.description
        self.deviceId = deviceId
        super.init()
    }
    
    public func toDictionary() -> [String: String] {
        var dict: [String: String] = [
            Keys.DeviceId: self.deviceId,
            Keys.Network: self.network
        ]
        
        if let email = self.email {
            dict.updateValue(email, forKey: Keys.Email)
        }
        
        if let password = self.password {
            dict.updateValue(password, forKey: Keys.Password)
        }
        
        if let token = self.token {
            dict.updateValue(token, forKey: Keys.Token)
        }
        
        return dict
    }
    
}
