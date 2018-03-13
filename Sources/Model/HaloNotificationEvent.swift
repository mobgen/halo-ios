//
//  HaloNotificationEvent.swift
//  Halo-iOS
//
//  Created by Fernando Souto Gonzalez on 25/01/2018.
//  Copyright © 2018 MOBGEN Technology. All rights reserved.
//

import Foundation

@objc(HaloNotificationEvent)
public class HaloNotificationEvent: NSObject {
    
    struct Keys {
        static let Platform = "platform"
        static let Device = "device"
        static let Schedule = "schedule"
        static let Action = "action"
    }
    
    var device: String = "-"
    var schedule: String = "-"
    var action: String = "-"
    var platform: String = "-"
   
    public init(device: String, schedule: String, action: String) {
        self.device = device
        self.schedule = schedule
        self.action = action
        self.platform = "ios"
    }
    
    class func fromDictionary(_ dict: [String: Any?]) -> HaloNotificationEvent {
        
        let haloNotificationEvent = HaloNotificationEvent(device: dict[Keys.Device] as? String ?? "-",schedule: dict[Keys.Schedule] as? String ?? "-",action: dict[Keys.Action] as? String ?? "-")
        return haloNotificationEvent
    }
    
    func toDictionary() -> [String: Any] {
        return [
            Keys.Platform: platform,
            Keys.Schedule: schedule,
            Keys.Device: device,
            Keys.Action: action
        ]
    }
    
}

