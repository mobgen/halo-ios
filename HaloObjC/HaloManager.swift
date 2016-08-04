//
//  HaloManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

public class HaloManager: NSObject {
    
    public static let core = HaloCoreManager.sharedInstance
    public static let generalContent = HaloContentManager.sharedInstance
    
    private override init() {
        super.init()
    }
    
}