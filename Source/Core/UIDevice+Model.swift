//
//  File.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 07/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import UIKit

private let DeviceList = [
    "iPod7,1"		: "iPod touch 6",
    "iPad5,4"		: "iPad Air 2 (Cellular)",
    "iPad5,3"		: "iPad Air 2 (WiFi)",
    "iPad4,9"		: "iPad Mini 3 (China)",
    "iPad4,8"		: "iPad Mini 3 (Cellular)",
    "iPad4,7"		: "iPad Mini 3 (WiFi)",
    "iPhone7,2"		: "iPhone 6",
    "iPhone7,1"		: "iPhone 6 Plus",
    "iPad4,6"		: "iPad Mini 2 (China)",
    "iPad4,3"		: "iPad Air (China)",
    "iPad4,5"		: "iPad Mini 2 (Cellular)",
    "iPad4,4"		: "iPad Mini 2 (WiFi)",
    "iPad4,2"		: "iPad Air (Cellular)",
    "iPad4,1"		: "iPad Air (WiFi)",
    "iPhone6,2"		: "iPhone 5s (Global)",
    "iPhone6,1"		: "iPhone 5s (GSM)",
    "iPhone5,4"		: "iPhone 5c (Global)",
    "iPhone5,3"		: "iPhone 5c (GSM)",
    "iPad3,6"		: "iPad 4 (Global)",
    "iPad3,5"		: "iPad 4 (GSM)",
    "iPad2,7"		: "iPad Mini (Global)",
    "iPad2,6"		: "iPad Mini (GSM)",
    "iPad3,4"		: "iPad 4 (WiFi)",
    "iPad2,5"		: "iPad Mini (WiFi)",
    "iPod5,1"		: "iPod touch 5",
    "iPhone5,2"		: "iPhone 5 (Global)",
    "iPhone5,1"		: "iPhone 5 (GSM)",
    "iPad3,3"		: "iPad 3 (GSM)",
    "iPad3,2"		: "iPad 3 (CDMA)",
    "iPad3,1"		: "iPad 3 (WiFi)",
    "iPad2,4"		: "iPad 2 (Mid 2012)",
    "iPhone4,1"		: "iPhone 4s",
    "iPad2,3"		: "iPad 2 (CDMA)",
    "iPad2,2"		: "iPad 2 (GSM)",
    "iPad2,1"		: "iPad 2 (WiFi)",
    "Watch1,2"		: "Apple Watch (42mm)",
    "Watch1,1"		: "Apple Watch (38mm)",
    "AppleTV3,2"	: "Apple TV 3 (2013)",
    "AppleTV3,1"	: "Apple TV 3",
    "AppleTV2,1"	: "Apple TV 2G",
    "iPhone3,2"		: "iPhone 4 (GSM / 2012)",
    "iPhone3,3"		: "iPhone 4 (CDMA)",
    "iPhone3,1"		: "iPhone 4 (GSM)",
    "iPod4,1"		: "iPod touch 4",
    "iPhone2,1"		: "iPhone 3Gs",
    "iPad1,1"		: "iPad 1",
    "iPod3,1"		: "iPod touch 3",			
    "iPod2,1"		: "iPod touch 2G",			
    "iPhone1,2"		: "iPhone 3G",					
    "iPhone1,1"		: "iPhone 2G",					
    "iPod1,1"		: "iPod touch 1G",
    "x86_64"        : "Simulator",
    "i386"          : "Simulator"
]

public extension UIDevice {

    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)
        var identifier = ""

        for child in mirror.children where child.value as? Int8 != 0 {
            identifier.append(UnicodeScalar(UInt8(child.value as! Int8)))
        }

        return DeviceList[identifier] ?? identifier
    }

}

