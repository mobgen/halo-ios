//
//  MockNetworkAddon.swift
//  Halo
//
//  Created by Miguel López on 22/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
@testable import Halo

class MockNetworkAddon : DummyAddon, NetworkAddon {
    
    override init() {
        super.init()
        addonName = "MockNetworkAddon"
    }
    
    func willPerformRequest(request req: URLRequest) {
        
    }
    
    func didPerformRequest(request req: URLRequest, time: TimeInterval, response: URLResponse?) {
        
    }
}
