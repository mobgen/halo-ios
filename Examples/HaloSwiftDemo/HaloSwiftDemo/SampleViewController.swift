//
//  SampleViewController.swift
//  HALOSwiftDemo
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import UIKit
import Halo

class SampleViewController: UIViewController, UITextFieldDelegate {

    var myView:SampleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView = view as! SampleView
        
        myView!.button.addTarget(self, action: "login:", forControlEvents: .TouchUpInside)
        myView!.clientId.delegate = self
        myView!.clientSecret.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func login(sender: UIButton) {
        sender.becomeFirstResponder()
        
        let mgr = Halo.Manager.sharedInstance
        
        var title = "Awww.. :("
        var message = "Sorry man, wrong credentials!"
        
        mgr.authenticate(myView.clientId.text, clientSecret: myView.clientSecret.text) { (result) -> Void in
            switch result {
            case .Success(let tokenObj):
                title = "Wahey!"
                let token:String = tokenObj.token
                let date:String = NSDateFormatter.localizedStringFromDate(tokenObj.expirationDate, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
                message = "Successfully authenticated!\nAccess token: \(token)\nExpiration: \(date)"
            case .Failure(let error):
                NSLog("%s", error.localizedDescription)
            }
            
            self.showAlert(title, message: message)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
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

