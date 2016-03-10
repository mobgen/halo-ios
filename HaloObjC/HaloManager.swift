//
//  File.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

@objc
public class HaloManager: NSObject {
    
    public let core = HaloCoreManager.sharedInstance
    public let generalContent = HaloGeneralContentManager.sharedInstance
    
    public static let sharedInstance = HaloManager()
    
    private override init() {
        super.init()
    }
    
}