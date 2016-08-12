//
//  CoreConstants.swift
//  HALOFramework
//
//  Created by Borja Santos-Díez on 02/07/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

/// Utility class containing some of the constants to be used within the SDK
public class CoreConstants {

    /// Key to be used to store the latest environment used
    public static let environmentKey = "HaloEnvironment"

    /// Key which identifies the client id within the configuration plist
    static let clientIdKey = "CLIENT_ID"

    /// Key which identifies the client secret within the configuration plist
    static let clientSecretKey = "CLIENT_SECRET"

    static let environmentSettingKey = "ENVIRONMENT"

    /// Key which identifies the username within the configuration plist
    static let usernameKey = "USERNAME"

    /// Key which identifies the user password within the configuration plist
    static let passwordKey = "PASSWORD"

    /// Key which identifies the option to enable push notifications within the configuration plist
    static let enableSystemTags = "ENABLE_SYSTEM_TAGS"

    static let disableSSLpinning = "DISABLE_SSL_PINNING"

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
