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

    func getUser(user: Halo.User, completionHandler handler: ((Alamofire.Result<Halo.User, NSError>) -> Void)? = nil) -> Void {
        
        if let id = user.id {
            
            self.startRequest(Router.SegmentationGetUser(id)) { (request, response, result) in
                
                if let resp = response {
                    
                    if (resp.statusCode == 200) {
                        switch result {
                        case .Success(let data):
                            let user = User.fromDictionary(data as! [String: AnyObject])
                            handler?(.Success(user))
                        case .Failure(let error):
                            handler?(.Failure(error))
                        }
                    }
                }
            }
            
        } else {
            handler?(.Success(user))
        }
        
    }
    
    /**
    Create or update a user in the remote server, containing all the user details (devices, tags, etc)

    :param: user    User object containing all the information to be sent
    :param: handler Closure to be executed after the request has completed
    */
    func createUpdateUser(user: Halo.User, completionHandler handler: ((Alamofire.Result<Halo.User, NSError>) -> Void)? = nil) -> Void {

        /// Decide whether to create or update the user based on the presence of an id
        let request: URLRequestConvertible;
        
        if let id = user.id {
            request = Router.SegmentationUpdateUser(id, user.toDictionary())
        } else {
            request = Router.SegmentationCreateUser(user.toDictionary())
        }
        
        self.startRequest(request) { (req, resp, result) -> Void in

            if let response = resp {

                if (response.statusCode == 200) {

                    switch result {
                    case .Success(let data):
                        let user = User.fromDictionary(data as! [String: AnyObject])
                        handler?(.Success(user))
                    case .Failure(let error):
                        handler?(.Failure(error))
                    }
                    
                } else {
                    handler?(.Failure(NSError(domain: "com.mobgen.halo", code: 0, userInfo: [NSLocalizedDescriptionKey : "Error creating user"])))
                }
            } else {
                handler?(.Failure(NSError(domain: "com.mobgen.halo", code: 0, userInfo: [NSLocalizedDescriptionKey : "No response received from server"])))
            }
        }
    }

}
