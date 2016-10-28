//
//  NSDate+Utils.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 22/09/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

extension Date: Comparable {}

public func ==(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
}

public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}
