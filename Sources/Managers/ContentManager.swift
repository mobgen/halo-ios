//
//  GeneralContent.swift
//  HaloSDK
//
//  Created by Borja on 31/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

/**
 Access point to the General Content. This class will provide methods to obtain the data stored as general content.
 */
@objc(HaloContentManager)
open class ContentManager: NSObject, HaloManager {

    open var defaultLocale: Halo.Locale?
    
    let serverCachingTime = "86400000"
    
    static var filePath: URL {
        let manager = FileManager.default
        return manager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    fileprivate override init() {
        super.init()
    }

    @objc(startup:)
    open func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {
        handler?(true)
    }

    // MARK: Get instances

    open func search(query: Halo.SearchQuery, completionHandler handler: @escaping (HTTPURLResponse?, Halo.Result<PaginatedContentInstances?>) -> Void) -> Void {
        Manager.core.dataProvider.search(query: query, completionHandler: handler)
    }

    // MARK: Content manipulation
    
    open func saveContent(_ instance: ContentInstance) -> ContentInstance? {
        
        
        
        return nil
    }
    
    open func deleteContent(id: String) -> Bool {
        
        
        return true
    }
}

public extension Manager {
    
    public static let content: ContentManager = {
        return ContentManager()
    }()
    
}