//
//  NetworkingConstants.swift
//  HALOFramework
//
//  Created by Borja Santos-Díez on 02/07/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

enum HaloURL: String {
    
    case ModulesList = "api/authentication/module/list"
    case OAuth = "api/oauth/token?_1"
    
    var URL: String {
        return "http://halo-int.mobgen.com:3000/\(self.rawValue)"
    }
    
}