//
//  Networking.swift
//  MoMOSFramework
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire
import Result

/// Module encapsulating all the networking features of the Framework
class Networking {

    let alamofire = Alamofire.Manager.sharedInstance

    static let sharedInstance = Networking()

    /// Client id to be used for authentication throughout the SDK
    var clientId: String?

    /// Client secret to be used for authentication throughout the SDK
    var clientSecret: String?

    /**
    Authenticate against the HALO backend using a client id and a client secret

    :param: clientId            Client id to be used for authentication
    :param: clientSecret        Client secret to be used for authentication
    :param: completionHandler   Callback where the response from the server can be processed
    */
    func authenticate(completionHandler handler: (result: Result<HaloToken, NSError>) -> Void) -> Void {

        if let haloToken = Router.token {
            if haloToken.isExpired() {
                /// Refresh token
                haloAuthenticate(haloToken.refreshToken, completionHandler: handler)
            } else {
                handler(result: .Success(haloToken))
            }
        } else {
            haloAuthenticate(nil, completionHandler: handler)
        }
    }

    /**
    Internal call to the authentication process. If a refresh token is provided, then the existing
    token is refreshed. Otherwise, a fresh one is requested

    :param: refreshToken        Refresh token (if any)
    :param: completionHandler   Callback to handle the result of the request
    */
    private func haloAuthenticate(refreshToken: String?, completionHandler handler: (result: Result<HaloToken, NSError>) -> Void) -> Void {

        let params:[String: String]

        if let refresh = refreshToken {
            params = [
                "grant_type" : "refresh_token",
                "client_id" : clientId!,
                "client_secret" : clientSecret!,
                "refresh_token" : refresh
            ]
        } else {
            params = [
                "grant_type" : "client_credentials",
                "client_id" : clientId!,
                "client_secret" : clientSecret!
            ]
        }

        alamofire.request(Router.OAuth(params)).responseJSON { (req, resp, json, error) -> Void in
            if let jsonDict = json as? Dictionary<String,AnyObject> {

                let token = HaloToken(dict: jsonDict)

                Router.token = token
                handler(result: .Success(token))

            } else {
                handler(result: .Failure(error!))
            }
        }
    }

    /**
    Get the list of available modules for a given client id/client secret pair

    :param: completionHandler   Callback executed when the request has finished
    */
    func getModules(completionHandler handler: (result: Result<[HaloModule], NSError>) -> Void) -> Void {

        if let tok = Router.token {

            if tok.isValid() {

                alamofire.request(Router.Modules).responseJSON(completionHandler: { (_, _, json, error) -> Void in

                    if let jsonArr = json as? [Dictionary<String,AnyObject>] {
                        let arr = self.parseModules(jsonArr)
                        handler(result:.Success(arr))
                    } else {
                        let error = NSError(domain: "halo.mobgen.com", code: 100, userInfo: nil)
                        handler(result:.Failure(error))
                    }
                });
            } else {
                self.authenticate { (result) -> Void in
                    switch (result) {
                    case .Success(_):
                        self.getModules(completionHandler: handler)
                    case .Failure(let err):
                        print("Error: \(err.localizedDescription)")
                    }
                }
            }

        } else {
            authenticate { (result) -> Void in
                switch (result) {
                case .Success(_) :
                    self.getModules(completionHandler: handler)
                case .Failure(let err):
                    print("Error: \(err.localizedDescription)")
                }
            }
        }
    }

    /**
    Parse a list of dictionaries (from the JSON response) into a list of modules
    
    :param:     modules     List of dictionaries coming from the JSON response
    :returns:   The list of the parsed modules
    */
    private func parseModules(modules: [Dictionary<String,AnyObject>]) -> [HaloModule] {

        var modArray = [HaloModule]()

        for dict in modules {
            modArray.append(HaloModule(dict: dict))
        }

        return modArray
    }
}
