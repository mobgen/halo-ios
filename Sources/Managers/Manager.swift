//
//  Manager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit

/**
Enumeration holding the different environment options available

- Int:    Integration environment
- QA:     QA environment
- Stage:  Stage environment
- Prod:   Production environment
- Custom: Custom environment (providing the full url)
*/
public enum HaloEnvironment {
    case int
    case qa
    case stage
    case prod
    case custom(String)

    public init(rawValue: String) {
        switch (rawValue.lowercased()) {
        case "int": self = .int
        case "qa": self = .qa
        case "stage": self = .stage
        case "prod": self = .prod
        default: self = .custom(rawValue)
        }
    }

    var baseUrl: URL {
        switch self {
        case .int:
            return URL(string: "https://int.halo-db.com")!
        case .qa:
            return URL(string: "https://stage.halo-db.com")!
        case .stage:
            return URL(string: "https://stage.halo-db.com")!
        case .prod:
            return URL(string: "https://halo-db.com")!
        case .custom(let url):
            return URL(string: url)!
        }
    }

    public var description: String {
        switch self {
        case .int:
            return "Int"
        case .qa:
            return "QA"
        case .stage:
            return "Stage"
        case .prod:
            return "Prod"
        case .custom(let url):
            return url
        }
    }

    public var baseUrlString: String {
        get {
            return self.baseUrl.absoluteString
        }
    }
}

@objc
public enum OfflinePolicy: Int {
    case none, loadAndStoreLocalData, returnLocalDataDontLoad
}

@objc(HaloManager)
public class Manager: NSObject {
    
}
