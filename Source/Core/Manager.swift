//
//  Manager.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit

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

    public init(rawValue: String) {
        switch (rawValue.lowercaseString) {
        case "int": self = .Int
        case "qa": self = .QA
        case "stage": self = .Stage
        case "prod": self = .Prod
        default: self = .Custom(rawValue)
        }
    }

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

    public var description: String {
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

    public var baseUrlString: String {
        get {
            return self.baseUrl.absoluteString
        }
    }
}

@objc public enum OfflinePolicy: Int {
    case None, LoadAndStoreLocalData, ReturnLocalDataDontLoad
}

public struct Manager {

    public static let core: CoreManager = {
       return CoreManager()
    }()

    public static let content: ContentManager = {
       return ContentManager()
    }()

    public static let network: NetworkManager = {
        return NetworkManager()
    }()

}
