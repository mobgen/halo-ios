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
            if provisions.boolValue! {
                return .Enterprise
            }
        } else if let devices = mobileProvision["ProvisionedDevices"] as? NSArray where devices.count > 0 {
            
            if let entitlements = mobileProvision["Entitlements"] as? NSDictionary {
                if let taskAllow = entitlements["get-task-allow"] {
                    return taskAllow.boolValue! ? .Development : .AdHoc
                }
            }
        } else {
            return .AppStore
        }
            
        return .Unknown

    }
    
    static func getMobileProvision() -> NSDictionary? {
    
        var mobileProvision: NSDictionary?
        
        if let provisioningPath = NSBundle.mainBundle().pathForResource("embedded", ofType: "mobileprovision") {
            
            let binaryString = try! String(contentsOfFile: provisioningPath, encoding: NSISOLatin1StringEncoding)
            
            let scanner = NSScanner(string: binaryString)
            
            if !scanner.scanUpToString("<plist", intoString: nil) {
                return mobileProvision
            }
            
            var plistString: NSString?
            
            scanner.scanUpToString("</plist>", intoString: &plistString)
            
            plistString = plistString?.stringByAppendingString("</plist>")
            
            if let plistData = plistString?.dataUsingEncoding(NSISOLatin1StringEncoding) {
                mobileProvision = try! NSPropertyListSerialization.propertyListWithData(plistData, options: .Immutable, format: nil) as? NSDictionary
            }
        }
        
        return mobileProvision
        
    }
}