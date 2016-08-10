//
//  DataProvider.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 10/08/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public protocol DataProvider {

    var numberOfRetries: Int { get set }

    func responseData(request: Requestable, completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<NSData, NSError>) -> Void)?) throws -> Void

    func response(request: Requestable, completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<AnyObject, NSError>) -> Void)?) throws -> Void

    func responseObject<T>(request: Halo.Request<T>,
                        completionHandler handler: ((NSHTTPURLResponse?, Halo.Result<T?, NSError>) -> Void)?) throws -> Void

}
