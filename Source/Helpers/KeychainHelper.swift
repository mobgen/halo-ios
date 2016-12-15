//
//  KeychainHelper.swift
//  Halo
//
//  Created by Borja Santos-Díez on 15/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloKeychainHelper)
public class KeychainHelper: NSObject {
    
    @discardableResult
    @objc(setString:forKey:)
    public static func set(_ value: String, forKey: String) -> Bool {
        return KeychainWrapper.standard.set(value, forKey: forKey)
    }
    
    @discardableResult
    public static func set(_ value: Int, forKey: String) -> Bool {
        return KeychainWrapper.standard.set(value, forKey: forKey)
    }
    
    @discardableResult
    @objc(setData:forKey:)
    public static func set(_ value: Data, forKey: String) -> Bool {
        return KeychainWrapper.standard.set(value, forKey: forKey)
    }
    
    @discardableResult
    @objc(setObject:forKey:)
    public static func set(_ value: NSCoding, forKey: String) -> Bool {
        return KeychainWrapper.standard.set(value, forKey: forKey)
    }
    
    @objc(stringForKey:)
    public static func string(forKey: String) -> String? {
        return KeychainWrapper.standard.string(forKey: forKey)
    }
    
    public static func integer(forKey: String) -> Int? {
        return KeychainWrapper.standard.integer(forKey: forKey)
    }
    
    public static func data(forKey: String) -> Data? {
        return KeychainWrapper.standard.data(forKey: forKey)
    }
    
    @objc(objectForKey:)
    public static func object(forKey: String) -> NSCoding? {
        return KeychainWrapper.standard.object(forKey: forKey)
    }
    
    public static func remove(forKey: String) -> Bool {
        return KeychainWrapper.standard.removeObject(forKey: forKey)
    }
}
