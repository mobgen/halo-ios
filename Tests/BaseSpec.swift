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
            if let url = request.URL, name = stub.name {
                print("\(url) stubbed by \"\(name).\"")
            }
        }
        
        beforeSuite {
            NSLog("-- Executing before suite")
        }
        
        afterSuite {
            NSLog("-- Executing after suite")
            OHHTTPStubs.removeAllStubs()
        }
    
    }
    
}
