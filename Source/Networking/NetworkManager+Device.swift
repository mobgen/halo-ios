//
//  NetworkManager+User.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 26/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation

extension NetworkManager {

    func deviceParser(data: AnyObject) -> Halo.Device? {
        if let dict = data as? [String: AnyObject] {
            return Device.fromDictionary(dict: dict)
        }
        return nil
    }
    
    func getDevice(device: Halo.Device, completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<Halo.Device?>) -> Void)? = nil) -> Void {

        if let id = device.id {

            let request = Halo.Request<Halo.Device>(router: Router.SegmentationGetDevice(id))
            try! request.responseParser(parser: self.deviceParser).responseObject(completionHandler: handler)

        } else {
            handler?(nil, .Success(device, false))
        }

    }

    /**
    Create or update a user in the remote server, containing all the user details (devices, tags, etc)

    - parameter user:    User object containing all the information to be sent
    - parameter handler: Closure to be executed after the request has completed
    */
    func createUpdateDevice(device: Halo.Device, completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<Halo.Device?>) -> Void)? = nil) -> Void {

        /// Decide whether to create or update the user based on the presence of an id
        var request: Halo.Request<Halo.Device>

        if let id = device.id {
            request = Halo.Request(router: Router.SegmentationUpdateDevice(id, device.toDictionary()))
        } else {
            request = Halo.Request(router: Router.SegmentationCreateDevice(device.toDictionary()))
        }

        try! request.responseParser(parser: self.deviceParser).responseObject(completionHandler: handler)
    }
}
