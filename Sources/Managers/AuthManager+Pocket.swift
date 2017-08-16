//
//  AuthManager+Pocket.swift
//  Halo
//
//  Created by Santos-Díez, Borja on 16/08/2017.
//  Copyright © 2017 MOBGEN Technology. All rights reserved.
//

extension AuthManager {
    
    @objc(getPocket:)
    public func getPocket(completionHandler handler: @escaping (Pocket?) -> Void) -> Void {
        
        do {
            try Request<Pocket>(Router.getPocket).authenticationMode(.user).responseParser(pocketParser).responseObject { response, result in
                
                switch result {
                case .success(let pocket, _):
                    handler(pocket)
                case .failure(let error):
                    Manager.core.logMessage("There was an error retrieving the pocket: \(error.localizedDescription)", level: .error)
                    handler(nil)
                }
            }
        } catch {
            Manager.core.logMessage("There was an error retrieving the pocket: \(error.localizedDescription)", level: .error)
            handler(nil)
        }
    }
    
    @objc(savePocket:completionHandler:)
    public func savePocket(_ pocket: Pocket, completionHandler handler: @escaping (Pocket?) -> Void) -> Void {
        
        do {
            try Request<Pocket>(Router.savePocket(pocket.toDictionary())).authenticationMode(.user).responseParser(pocketParser).responseObject { response, result in
                
                switch result {
                case .success(let pocket, _):
                    handler(pocket)
                case .failure(let error):
                    Manager.core.logMessage("There was an error saving the pocket: \(error.localizedDescription)", level: .error)
                    handler(nil)
                }
            }
        } catch {
            Manager.core.logMessage("There was an error saving the pocket: \(error.localizedDescription)", level: .error)
            handler(nil)
        }
        
    }
    
    // MARK: Helper functions
    
    private func pocketParser(_ data: Any?) -> Pocket? {
        var object: Pocket?
        
        if let response = data as? [String: Any?] {
            object = Pocket.fromDictionary(response)
        }
        
        return object
    }
}
