//
//  NetworkManager+NSURLSessionDelegate.swift
//  Halo
//
//  Created by Borja Santos-Díez on 15/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

extension NetworkManager: URLSessionDelegate {
    
    // MARK: NSURLSessionDelegate implementation
    
    open func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var disposition: Foundation.URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let host = challenge.protectionSpace.host
            
            if let serverTrust = challenge.protectionSpace.serverTrust {
                if !self.enableSSLpinning || evaluateServerTrust(serverTrust: serverTrust, isValidForHost: host) {
                    disposition = .useCredential
                    credential = URLCredential(trust: serverTrust)
                } else {
                    disposition = .cancelAuthenticationChallenge
                }
            }
        }
        
        completionHandler(disposition, credential)
    }
    
}
