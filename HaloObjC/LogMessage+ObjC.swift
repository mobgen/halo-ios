//
//  LogMessage+ObjC.swift
//  Halo
//
//  Created by Borja Santos-Díez on 17/01/17.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

import Foundation
import Halo

extension LogMessage {
    
    public convenience init(message: String? = nil, error: NSError) {
        
        var finalMessage: String
        
        if let msg = message {
            finalMessage = "\(msg): \(error.description)"
        } else {
            finalMessage = error.description
        }
        
        self.init(message: finalMessage, level: .error)
    }
    
}
