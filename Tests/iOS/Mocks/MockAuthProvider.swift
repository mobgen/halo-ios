//
//  MockAuthProvider.swift
//  Halo
//
//  Created by Miguel López on 22/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
@testable import Halo

class MockAuthProvider : AuthProvider {
    
    var isLogoutCalled = false
    
    func logout() {
        isLogoutCalled = true
    }
}
