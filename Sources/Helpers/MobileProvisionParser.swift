//
//  MobileProvisionParser.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 03/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

enum ApplicationReleaseMode: String {
    case Unknown,
    Simulator,
    Development,
    AdHoc,
    AppStore,
    Enterprise
}

class MobileProvisionParser {

    static func applicationReleaseMode() -> ApplicationReleaseMode {

        guard let mobileProvision = self.getMobileProvision() else {
            return .Unknown
        }

        if mobileProvision.count == 0 {
            #if TARGET_IPHONE_SIMULATOR
            return .Simulator
            #else
            return .AppStore
            #endif
        } else if let provisions = mobileProvision["ProvisionsAllDevices"] {
            if (provisions as AnyObject).boolValue! {
                return .Enterprise
            }
        } else if let devices = mobileProvision["ProvisionedDevices"] as? NSArray , devices.count > 0 {

            if let entitlements = mobileProvision["Entitlements"] as? NSDictionary {
                if let taskAllow = entitlements["get-task-allow"] {
                    return (taskAllow as AnyObject).boolValue! ? .Development : .AdHoc
                }
            }
        } else {
            return .AppStore
        }

        return .Unknown

    }

    static func getMobileProvision() -> NSDictionary? {

        var mobileProvision: NSDictionary?
        
        if let provisioningPath = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision"),
            let binaryString = try? String(contentsOfFile: provisioningPath, encoding: String.Encoding.isoLatin1) {
            
            let scanner = Scanner(string: binaryString)
            
            if !scanner.scanUpTo("<plist", into: nil) {
                return mobileProvision
            }
            
            var plistString: NSString?
            
            scanner.scanUpTo("</plist>", into: &plistString)
            
            plistString = plistString?.appending("</plist>") as NSString?
            
            if let plistData = plistString?.data(using: String.Encoding.isoLatin1.rawValue) {
                mobileProvision = try! PropertyListSerialization.propertyList(from: plistData, options: PropertyListSerialization.MutabilityOptions(), format: nil) as? NSDictionary
            }
        }

        return mobileProvision

    }
}
