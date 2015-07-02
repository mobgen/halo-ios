//
//  SampleViewController.swift
//  HALOSwiftDemo
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import UIKit
import HALOCore
import HALONetworking

class SampleViewController: UIViewController, UITextFieldDelegate {

    var myView:SampleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Manual init when the HALO.plist file is not present
        
        // Manager.sharedInstance.apiKey = "apikey"
        // Manager.sharedInstance.clientSecret = "clientsecret"
        // Manager.sharedInstance.addModule(Networking(name: "networking"))
        
        myView = view as? SampleView
        
        myView!.button.addTarget(self, action: "login:", forControlEvents: .TouchUpInside)
        myView!.clientId.delegate = self
        myView!.clientSecret.delegate = self
        
        // Start HALO
        Manager.sharedInstance.launch()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func login(sender: UIButton) {
        sender.becomeFirstResponder()
        
        let net = Manager.sharedInstance.getModule("networking") as! Networking

        net.haloModules { (result) -> Void in
            self.navigationController?.pushViewController(ModuleListTableViewController(modules: result.value), animated: true)
        }
        
//        net.haloAuthenticate(myView!.clientId.text, clientSecret: myView!.clientSecret.text) { (responseObject, err) -> Void in
//            
//            var title: String
//            var message: String
//            
//            if let json = responseObject {
//                let token = json["access_token"] as? String
//                title = "Wahey!"
//                message = "Access token: \(token!)"
//            } else {
//                title = "Awww"
//                message = "Sorry man. Wrong credentials"
//            }
//         
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == myView!.clientId {
            myView!.clientSecret.becomeFirstResponder()
        } else {
            login(myView!.button)
        }
        
        return true
    }
    
    override func loadView() {
        view = SampleView(frame: CGRectZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

