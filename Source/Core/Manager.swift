//
//  Manager.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

/**
Enumeration holding the different environment options available

- Int:   Integration environment
- QA:    QA environment
- Stage: Stage environment
- Prod:  Production environment
*/
public enum HaloEnvironment {
    case Int
    case QA
    case Stage
    case Prod
    case Custom(String)
    
    var baseUrl: NSURL {
        switch self {
        case .Int:
            return NSURL(string: "https://halo-int.mobgen.com")!
        case .QA:
            return NSURL(string: "https://halo-qa.mobgen.com")!
        case .Stage:
            return NSURL(string: "https://halo-stage.mobgen.com")!
        case .Prod:
            return NSURL(string: "https://halo.mobgen.com")!
        case .Custom(let url):
            return NSURL(string: url)!
        }
    }
    
    var description: String {
        switch self {
        case .Int:
            return "Int"
        case .QA:
            return "QA"
        case .Stage:
            return "Stage"
        case .Prod:
            return "Prod"
        case .Custom(let url):
            return url
        }
    }
}

public enum OfflinePolicy {
    case None
    case LoadAndStoreLocalData
    case ReturnLocalDataDontLoad
}

protocol HaloManager {
    
    mutating func startup(completionHandler handler: (Bool) -> Void) -> Void
    
}

public struct Manager {
    
    public static var core: CoreManager = {
       return CoreManager()
    }()
    
    static var network: NetworkManager = {
        return NetworkManager()
    }()
    
    static var persistence: PersistenceManager = {
        return PersistenceManager()
    }()
}