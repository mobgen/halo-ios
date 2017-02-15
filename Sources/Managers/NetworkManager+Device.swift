//
//  NetworkManager+User.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 26/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

extension NetworkManager {

    func deviceParser(_ data: Any?) -> Halo.Device? {
        if let dict = data as? [String: Any] {
            return Device.fromDictionary(dict: dict)
        }
        return nil
    }
    
    func getDevice(_ device: Halo.Device, completionHandler handler: ((HTTPURLResponse?, Halo.Result<Halo.Device?>) -> Void)? = nil) -> Void {

        if let id = device.id {

            let request = Halo.Request<Halo.Device>(router: Router.segmentationGetDevice(id), bypassReadiness: true)
            try! request.responseParser(self.deviceParser).responseObject(handler)

        } else {
            handler?(nil, .success(device, false))
        }

    }

    /**
    Create or update a user in the remote server, containing all the user details (devices, tags, etc)

    - parameter user:    User object containing all the information to be sent
    - parameter handler: Closure to be executed after the request has completed
    */
    func createUpdateDevice(_ device: Halo.Device, bypassReadiness: Bool = false, completionHandler handler: ((HTTPURLResponse?, Halo.Result<Halo.Device?>) -> Void)? = nil) -> Void {

        /// Decide whether to create or update the user based on the presence of an id
        var request: Halo.Request<Halo.Device>

        if let id = device.id {
            request = Halo.Request(router: Router.segmentationUpdateDevice(id, device.toDictionary()), bypassReadiness: bypassReadiness)
        } else {
            request = Halo.Request(router: Router.segmentationCreateDevice(device.toDictionary()), bypassReadiness: bypassReadiness)
        }

        try! request.responseParser(self.deviceParser).responseObject(handler)
    }
}
