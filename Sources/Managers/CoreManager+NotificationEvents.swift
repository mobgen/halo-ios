//
//  CoreManager+NotificationEvents.swift
//  Halo-iOS
//
//  Created by Fernando Souto Gonzalez on 25/01/2018.
//  Copyright © 2018 MOBGEN Technology. All rights reserved.
//

import Foundation

extension CoreManager {
    
    /**
     Send a notification action event { dismiss, open, receipt }
     */
    public func sendNotificationEvent(_ halonotificationEvent: HaloNotificationEvent, completionHandler handler: @escaping (HTTPURLResponse?, Result<HaloNotificationEvent?>) -> Void) -> Void {
        do {
            try Request<HaloNotificationEvent>(Router.notityPushEvent(halonotificationEvent.toDictionary())).responseParser(notificationEventParser).responseObject { response, result in

                switch result {
                case .success(let halonotificationEvent, _):
                    Manager.core.logMessage("Notification event: \(HaloNotificationEvent.Keys.Action)", level: .info)
                    handler(response, .success(halonotificationEvent, false))
                case .failure(let error):
                    Manager.core.logMessage("There was an error sending the notification event: \(error.localizedDescription)", level: .error)
                    handler(nil, .failure(error))
                }
            }
        } catch {
            Manager.core.logMessage("There was an error sending the notification event: \(error.localizedDescription)", level: .error)
            handler(nil, .failure(.unknownError(error)))
        }
    }
    
    // MARK: Helper functions
    private func notificationEventParser(_ data: Any?) -> HaloNotificationEvent? {
        var object: HaloNotificationEvent?
        
        if let response = data as? [String: Any?] {
            object = HaloNotificationEvent.fromDictionary(response)
        }
        
        return object
    }
}
