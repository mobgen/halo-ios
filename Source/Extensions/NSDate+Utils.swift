//
//  NSDate+Utils.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 22/09/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

extension NSDate: Comparable {}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}
