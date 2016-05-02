//
//  GCMManager.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 29/02/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

class GCMManager: NSObject, GGLInstanceIDDelegate {
    
    static let sharedInstance = GCMManager()
    
    /// GCM sender id
    var gcmSenderId: String?
    
    var deviceToken: String?
    
    private override init() {
        super.init()
    }
    
    func configure() -> Void {
        var configureError:NSError?
        
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        self.gcmSenderId = GGLContext.sharedInstance().configuration.gcmSenderID
    }
    
    func setupPushNotifications(token: NSData, development: Bool, completionHandler handler: () -> Void) -> Void {
        
        // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
        
        if let senderId = self.gcmSenderId {
            
            // Start the GGLInstanceID shared instance with that config and request a registration
            // token to enable reception of notifications
            let gcm = GGLInstanceID.sharedInstance()
            
            let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
            instanceIDConfig.delegate = self
            // Start the GGLInstanceID shared instance with that config and request a registration
            // token to enable reception of notifications
            gcm.startWithConfig(instanceIDConfig)
            
            let registrationOptions: [String : AnyObject] = [
                kGGLInstanceIDRegisterAPNSOption: token,
                kGGLInstanceIDAPNSServerTypeSandboxOption: development
            ]
            
            gcm.tokenWithAuthorizedEntity(senderId, scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: { (token, error) -> Void in
                
                if let currentUser = Manager.core.user, gcmToken = token {
                    self.deviceToken = gcmToken
                    
                    let device = UserDevice(platform: "ios", token: gcmToken)
                    currentUser.devices = [device]
                
                    NSLog("Push device token: \(gcmToken)")
                }
                
                handler()
            })
        } else {
            handler()
        }
        
    }
    
    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
        
        if let senderId = self.gcmSenderId, devToken = Manager.core.deviceToken {
            
            let registrationOptions = [
                kGGLInstanceIDRegisterAPNSOption: devToken,
                kGGLInstanceIDAPNSServerTypeSandboxOption: true
            ]
            
            GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(senderId,
                scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: { (token, error) -> Void in
                    
                    if let currentUser = Manager.core.user {
                        let device = UserDevice(platform: "ios", token: token)
                        currentUser.devices = [device]
                        
                        Manager.network.createUpdateUser(currentUser)
                    }
            })
        }
    }
    
}