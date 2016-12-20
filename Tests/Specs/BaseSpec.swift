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
            NSLog("BaseSpec -- Executing before suite")
        }
        
        afterSuite {
            NSLog("BaseSpec -- Executing after suite")
        }
    
    }
    
}
