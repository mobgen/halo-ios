//
//  ManagerProtocols.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 23/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

protocol ModulesManager {

    func getModules() -> Halo.Request<[Halo.Module]>
    //func getModules(fetchFromNetwork network: Bool, completionHandler handler: ((Halo.Result<[Halo.Module], NSError>) -> Void)?) -> Void
    
}

protocol GeneralContentManager {
    
    func generalContentInstances(moduleIds: [String], flags: GeneralContentFlag, fetchFromNetwork network: Bool, populate: Bool?, completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void
    func generalContentInstance(instanceId: String, fetchFromNetwork network: Bool, populate: Bool?, completionHandler handler: ((Halo.Result<Halo.GeneralContentInstance, NSError>) -> Void)?) -> Void
    func generalContentInstances(instanceIds: [String], fetchFromNetwork network: Bool, populate: Bool?, completionHandler handler: ((Halo.Result<[Halo.GeneralContentInstance], NSError>) -> Void)?) -> Void
    
}