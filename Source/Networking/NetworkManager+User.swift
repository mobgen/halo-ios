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

            Halo.Request<[String:AnyObject]>(router: Router.SegmentationGetUser(id)).response(completionHandler: { (request, response, result) in
                
                switch result {
                case .Success(let data, let cached):
                    let user = User.fromDictionary(data)
                    handler?(.Success(user, cached))
                case .Failure(let error):
                    handler?(.Failure(error))
                }
            })
            
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
        let request: Halo.Request<[String: AnyObject]>
        
        if let id = user.id {
            request = Halo.Request<[String: AnyObject]>(router: Router.SegmentationUpdateUser(id, user.toDictionary()))
        } else {
            request = Halo.Request<[String: AnyObject]>(router: Router.SegmentationCreateUser(user.toDictionary()))
        }
        
        self.startRequest(request: request) { (req, resp, result) -> Void in

            switch result {
            case .Success(let data, let cached):
                let user = User.fromDictionary(data)
                handler?(.Success(user, cached))
            case .Failure(let error):
                handler?(.Failure(error))
            }
        }
    }

}
