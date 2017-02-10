//
//  BaseSpec.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 26/09/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Halo

class BaseSpec: QuickSpec {
    
    override func spec() {
        
        OHHTTPStubs.onStubActivation() { request, stub, response in
            if let url = request.url, let name = stub.name {
                print("\(url) stubbed by \"\(name).\"")
            }
        }
        
        beforeSuite {
            // NSLog("BaseSpec -- Executing before suite")
            
            stub(condition: isPath("/api/segmentation/appuser")) { _ in
                let stubPath = OHPathForFile("segmentation_appuser_success.json", type(of: self))
                return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
            }.name = "Successful segmentation stub"
            
            stub(condition: isPath("/api/oauth/token")) { _ in
                let stubPath = OHPathForFile("oauth_success.json", type(of: self))
                return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
            }.name = "Successful oauth stub"
        }
        
        afterSuite {
            // NSLog("BaseSpec -- Executing after suite")
            
            OHHTTPStubs.removeAllStubs()
        }
    
    }
    
}
