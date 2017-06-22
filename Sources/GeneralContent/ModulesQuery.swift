//
//  ModulesQuery.swift
//  Halo
//
//  Created by Santos-Díez, Borja on 22/06/2017.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

open class ModulesQuery: NSObject {
    
    private(set) var serverCache: Int = 0
    
    @objc(serverCache:)
    open func serverCache(_ seconds: Int) -> ModulesQuery {
        self.serverCache = seconds
        return self
    }
    
}
