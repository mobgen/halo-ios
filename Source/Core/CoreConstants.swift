//
//  CoreConstants.swift
//  HALOFramework
//
//  Created by Borja Santos-Díez on 02/07/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/// Utility class containing some of the constants to be used within the SDK
class CoreConstants {

    /// Key which identifies the client id within the configuration plist
    static let clientIdKey = "CLIENT_ID"

    /// Key which identifies the client secret within the configuration plist
    static let clientSecret = "CLIENT_SECRET"

    // MARK: User defaults keys

    /// Key which identifies the existing user tags into the user defaults
    static let userDefaultsUserKey = "HALO_USER"

    static let tagPlatformNameKey = "Platform Name"

    static let tagPlatformVersionKey = "iOS Version"

    static let tagApplicationNameKey = "Application Name"

    static let tagApplicationVersionKey = "Application Version"

    static let tagDeviceManufacturerKey = "Device Manufacturer"

    static let tagDeviceModelKey = "Device Model"

    static let tagDeviceTypeKey = "Device Type"

    static let tagBLESupportKey = "Bluetooth 4 Support"

    static let tagNFCSupportKey = "NFC Support"

    static let tagDeviceScreenSizeKey = "Device Screen Size"

    static let tagTestDeviceKey = "Test Device"

}
