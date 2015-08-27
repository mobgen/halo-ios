//
//  NetworkManager+User.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 26/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

extension NetworkManager {

    func createUpdateUser(user: Halo.User, completionHandler handler: ((Alamofire.Result<Halo.User>) -> Void)? = nil) -> Void {

        /// Decide whether to create or update the user based on the presence of an id
        let request = user.id == nil ? Router.SegmentationCreateUser(user.toDictionary()) : Router.SegmentationUpdateUser(user.toDictionary())

        self.startRequest(request) { (req, resp, result) -> Void in

            if let response = resp {

                if (response.statusCode == 200) {

                    switch result {
                    case .Success(let data):
                        let user = User.fromDictionary(data as! [String: AnyObject])
                        handler?(.Success(user))
                    case .Failure(let data, let error):
                        handler?(.Failure(data, error))
                    }

                } else {
                    handler?(.Failure(nil, NSError(domain: "com.mobgen.halo", code: 0, userInfo: [NSLocalizedDescriptionKey : "Error creating user"])))
                }
            } else {
                handler?(.Failure(nil, NSError(domain: "com.mobgen.halo", code: 0, userInfo: [NSLocalizedDescriptionKey : "No response received from server"])))
            }
        }
    }

}
