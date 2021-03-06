//
//  NetworkManager+SSLPinning.swift
//  Halo
//
//  Created by Borja Santos-Díez on 15/12/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

extension NetworkManager {
    
    // MARK: SSL Pinning
    
    func evaluateServerTrust(serverTrust: SecTrust, isValidForHost host: String) -> Bool {
        let policy = SecPolicyCreateSSL(true, host as CFString)
        SecTrustSetPolicies(serverTrust, [policy] as AnyObject)
        
        SecTrustSetAnchorCertificates(serverTrust, certificatesInBundle(bundle: Bundle(identifier: "com.mobgen.Halo")!) as CFArray)
        SecTrustSetAnchorCertificatesOnly(serverTrust, true)
        
        return trustIsValid(trust: serverTrust)
    }
    
    
    fileprivate func certificatesInBundle(bundle: Bundle?) -> [SecCertificate] {
        var certificates: [SecCertificate] = []
        
        let main = Bundle.main
        let fileExtensions = [".cer", ".CER", ".crt", ".CRT", ".der", ".DER"]
        
        var paths: [String] = fileExtensions.flatMap { main.paths(forResourcesOfType: $0, inDirectory: nil) }
        
        if let bundle = bundle {
            paths.append(contentsOf: fileExtensions.flatMap { bundle.paths(forResourcesOfType: $0, inDirectory: nil) })
        }
        
        for path in paths {
            if let
                certificateData = try? Data(contentsOf: URL(fileURLWithPath: path)),
                let certificate = SecCertificateCreateWithData(nil, certificateData as CFData) {
                certificates.append(certificate)
            }
        }
        
        return certificates
    }
    
    fileprivate func trustIsValid(trust: SecTrust) -> Bool {
        var isValid = false
        
        var result = SecTrustResultType.invalid
        let status = SecTrustEvaluate(trust, &result)
        
        if status == errSecSuccess {
            let unspecified = SecTrustResultType.unspecified
            let proceed = SecTrustResultType.proceed
            
            isValid = result == unspecified || result == proceed
        }
        
        if isValid {
            Manager.core.logMessage("A valid certificate for the SSL pinning has been found", level: .info)
        } else {
            Manager.core.logMessage("No valid certificate was found within the main bundle", level: .error)
        }
        
        return isValid
    }
    
}
