//
//  GeneralContent.swift
//  HaloSDK
//
//  Created by Borja on 31/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

public class GeneralContent: NSObject {

    private let net = Networking.sharedInstance
    
    public func getModuleInstances(internalId: String, completionHandler handler: (Alamofire.Result<[Dictionary<String,AnyObject>]>) -> Void) -> Void {
        
    }
    
}