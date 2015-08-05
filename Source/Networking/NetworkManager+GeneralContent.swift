//
//  NetworkManager+GeneralContent.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 05/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import Alamofire

extension NetworkManager {

    /**
    Obtain the existing instances for a given General Content module

    - parameter moduleId:           Internal id of the module to be requested
    - parameter completionHandler:  Closure to be executed when the request has finished
    */
    func generalContentModule(moduleId: String, completionHandler handler: (Alamofire.Result<[GeneralContentInstance]>) -> Void) -> Void {

        self.startRequest(Router.GeneralContentInstances(["module" : moduleId])) { [weak self] (req, resp, result) -> Void in

            if let strongSelf = self {
                switch result {
                case .Success(let data):
                    let arr = strongSelf.parseGeneralContentInstances(data as! [Dictionary<String,AnyObject>])
                    handler(.Success(arr))
                case .Failure(let data, let error):
                    handler(.Failure(data, error))
                }
            }
        }
    }

    /**
    Utility function to parse the JSON coming from the request into an array of General Content instances

    - parameter instances:   Array of dictionaries (JSON) coming directly from the response

    - returns Array of parsed General Content instances
    */
    private func parseGeneralContentInstances(instances: [Dictionary<String, AnyObject>]) -> [GeneralContentInstance] {

        var gcInstances = [GeneralContentInstance]()

        for dict in instances {
            gcInstances.append(GeneralContentInstance(dict))
        }

        return gcInstances
    }

}