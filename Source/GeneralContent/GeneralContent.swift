//
//  GeneralContent.swift
//  HaloSDK
//
//  Created by Borja on 31/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import RealmSwift

public struct GeneralContentFlag : OptionSetType {
    
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let IncludeArchived = GeneralContentFlag(rawValue: 1)
    public static let IncludeUnpublished = GeneralContentFlag(rawValue: 2)
}

/**
 Access point to the General Content. This class will provide methods to obtain the data stored as general content.
 */
public struct GeneralContentManager: HaloManager {

    init() {}

    func startup(completionHandler handler: ((Bool) -> Void)?) -> Void {
        // Nothing to be done here yet
    }

    // MARK: Get instances
    
    /**
     Get the existing instances of a given General Content module
     
     - parameter moduleIds:          Internal ids of the modules from which we want to retrieve the instances
     - parameter offlinePolicy:      Offline policy to be considered when retrieving data
     - parameter completionHandler:  Closure to be executed when the request has finished
     */
    public func getInstances(moduleIds moduleIds: [String], options: Halo.SearchOptions? = nil) -> Halo.Request {
        
        var searchOptions = options ?? SearchOptions()
        searchOptions.addModuleIds(moduleIds)
        
        return self.searchInstances(searchOptions)
    }

    // MARK: Get instances by array of ids
    
    /**
     Get a set of general content instances by specifying their ids
     
     - parameter instanceIds:   Ids of the instances to be retrieved
     - parameter offlinePolicy: Offline policy to be considered when retrieving data
     - parameter handler:       Closure to be executed after the completion of the request
     */
    public func getInstances(instanceIds instanceIds: [String], options: Halo.SearchOptions? = nil) -> Halo.Request {
        
        var searchOptions = options ?? SearchOptions()
        searchOptions.addInstanceIds(instanceIds)
        
        return self.searchInstances(searchOptions)
    }
    
    
    public func searchInstances(searchOptions: Halo.SearchOptions) -> Halo.Request {
        
        let request = Halo.Request(router: Router.GeneralContentSearch)
        
        // Check offline mode
        if let offline = searchOptions.offlinePolicy {
            request.offlinePolicy(offline)
        }
        
        // Process the search options
        request.params(searchOptions.body)
        
        return request
    }

}