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

    func getUser(user: Halo.User, completionHandler handler: ((Halo.Result<Halo.User, NSError>) -> Void)? = nil) -> Void {
        
        if let id = user.id {

            let request = Halo.Request<Halo.User>(router: Router.SegmentationGetUser(id))
            
            request.responseParser { data in
                switch data {
                case let data as [String: AnyObject]:
                    return User.fromDictionary(data)
                default:
                    return nil
                }
            }
            
        } else {
            handler?(.Success(user, false))
        }
        
    }
    
    /**
    Create or update a user in the remote server, containing all the user details (devices, tags, etc)

    - parameter user:    User object containing all the information to be sent
    - parameter handler: Closure to be executed after the request has completed
    */
    func createUpdateUser(user: Halo.User, completionHandler handler: ((Halo.Result<Halo.User, NSError>) -> Void)? = nil) -> Void {

        /// Decide whether to create or update the user based on the presence of an id
        let request: Halo.Request<Halo.User>
        
        if let id = user.id {
            request = Halo.Request<Halo.User>(router: Router.SegmentationUpdateUser(id, user.toDictionary()))
        } else {
            request = Halo.Request<Halo.User>(router: Router.SegmentationCreateUser(user.toDictionary()))
        }

        request.responseParser { data in
            
            switch data {
            case let data as [String: AnyObject]:
                return User.fromDictionary(data)
            default:
                return nil
            }
        }

        request.response(completionHandler: handler)
    }
}
