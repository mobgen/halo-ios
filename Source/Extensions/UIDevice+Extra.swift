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
    "iPad5,4"		: "iPad Air 2",
    "iPad5,3"		: "iPad Air 2",
    "iPad4,9"		: "iPad Mini 3",
    "iPad4,8"		: "iPad Mini 3",
    "iPad4,7"		: "iPad Mini 3",
    "iPhone8,1"     : "iPhone 6s",
    "iPhone8,2"     : "iPhone 6s Plus",
    "iPhone7,2"		: "iPhone 6",
    "iPhone7,1"		: "iPhone 6 Plus",
    "iPad4,6"		: "iPad Mini 2",
    "iPad4,3"		: "iPad Air",
    "iPad4,5"		: "iPad Mini 2",
    "iPad4,4"		: "iPad Mini 2",
    "iPad4,2"		: "iPad Air",
    "iPad4,1"		: "iPad Air",
    "iPhone6,2"		: "iPhone 5S",
    "iPhone6,1"		: "iPhone 5S",
    "iPhone5,4"		: "iPhone 5C",
    "iPhone5,3"		: "iPhone 5C",
    "iPad3,6"		: "iPad 4",
    "iPad3,5"		: "iPad 4",
    "iPad2,7"		: "iPad Mini",
    "iPad2,6"		: "iPad Mini",
    "iPad3,4"		: "iPad 4",
    "iPad2,5"		: "iPad Mini",
    "iPod5,1"		: "iPod touch 5",
    "iPhone5,2"		: "iPhone 5",
    "iPhone5,1"		: "iPhone 5",
    "iPad3,3"		: "iPad 3",
    "iPad3,2"		: "iPad 3",
    "iPad3,1"		: "iPad 3",
    "iPad2,4"		: "iPad 2",
    "iPhone4,1"		: "iPhone 4S",
    "iPad2,3"		: "iPad 2",
    "iPad2,2"		: "iPad 2",
    "iPad2,1"		: "iPad 2",
    "Watch1,2"		: "Apple Watch",
    "Watch1,1"		: "Apple Watch",
    "AppleTV3,2"	: "Apple TV 3",
    "AppleTV3,1"	: "Apple TV 3",
    "AppleTV2,1"	: "Apple TV 2G",
    "iPhone3,2"		: "iPhone 4",
    "iPhone3,3"		: "iPhone 4",
    "iPhone3,1"		: "iPhone 4",
    "iPod4,1"		: "iPod touch 4",
    "iPhone2,1"		: "iPhone 3GS",
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

    /// Get the model name as a more readable string
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)
        var identifier = ""

        for child in mirror.children where child.value as? Int8 != 0 {
            identifier.append(UnicodeScalar(UInt8(child.value as! Int8)))
        }

        return getModelName(identifier)
    }

    /// Get the current device type (phone or tablet) as String
    var deviceType: String {
        return getDeviceType(UIDevice.currentDevice().userInterfaceIdiom)
    }

    /**
     Get the device type based on the user interface idiom

     - parameter idiom: User interface idiom of the device

     - returns: Device type
     */
    func getDeviceType(idiom: UIUserInterfaceIdiom) -> String {
        return (idiom == .Phone) ? "Phone" : "Tablet"
    }

    /**
     Get the model name of the current device from the not-so-descriptive identifier

     - parameter identifier: Device identifier

     - returns: More readable model name
     */
    func getModelName(identifier: String) -> String {
        return DeviceList[identifier] ?? identifier
    }
}
