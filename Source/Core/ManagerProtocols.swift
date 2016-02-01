//
//  ManagerProtocols.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 23/11/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

protocol ModulesManager {
    
    func getModules(fetchFromNetwork network: Bool, completionHandler handler: ((Alamofire.Result<[Halo.Module], NSError>, Bool) -> Void)?) -> Void
    
}

protocol GeneralContentManager {
    
    func generalContentInstances(moduleIds: [String], flags: GeneralContentFlag, fetchFromNetwork network: Bool, populate: Bool?, completionHandler handler: ((Alamofire.Result<[GeneralContentInstance], NSError>, Bool) -> Void)?) -> Void
    func generalContentInstance(instanceId: String, fetchFromNetwork network: Bool, populate: Bool?, completionHandler handler: ((Alamofire.Result<Halo.GeneralContentInstance, NSError>, Bool) -> Void)?) -> Void
    func generalContentInstances(instanceIds: [String], fetchFromNetwork network: Bool, populate: Bool?, completionHandler handler: ((Alamofire.Result<[Halo.GeneralContentInstance], NSError>, Bool) -> Void)?) -> Void
    
}