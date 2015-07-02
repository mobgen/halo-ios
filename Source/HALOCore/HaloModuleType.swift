//
//  ModuleType.swift
//  HALOFramework
//
//  Created by Borja Santos-Díez on 02/07/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc
public enum HaloModuleType: Int {
    
    case Core
    case Networking
    case Storage
    case Push
    
    public static func fromRaw(rawValue: String) -> HaloModuleType {
        switch rawValue {
        case "networking": return .Networking
        case "storage": return .Storage
        case "push": return .Push
        default: return .Core
        }
    }
    
    public var raw: String {
        switch self {
        case .Core: return "core"
        case .Networking: return "networking"
        case .Storage: return "storage"
        case .Push: return "push"
        }
    }
    
}