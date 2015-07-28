//
//  MoMOSCoreTests.swift
//  MoMOSCoreTests
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Quick
import Nimble
@testable import Halo

class CoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Manager.sharedInstance.launch()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Check whether the setup has been done correctly
    func testSDKSetup() {
        XCTAssertNotNil(Manager.sharedInstance, "Halo Manager shared instance is nil")
        XCTAssertNotNil(Manager.sharedInstance.networking, "Networking module is nil")
        XCTAssertNil(Manager.sharedInstance.clientId, "Client ID is not nil by default")
        XCTAssertNil(Manager.sharedInstance.clientSecret, "Client password is not nil by default")
    }

}
