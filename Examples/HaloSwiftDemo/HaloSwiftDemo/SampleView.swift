//
//  SampleView.swift
//  HALOSwiftDemo
//
//  Created by Borja Santos-Díez on 25/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import UIKit

class SampleView : UIView {
 
    let clientId:UITextField = UITextField(frame: CGRectZero)
    let clientSecret:UITextField = UITextField(frame: CGRectZero)
    let button:UIButton = UIButton(frame: CGRectZero)
    let logo:UIImageView = UIImageView(image: UIImage(named: "logo"))
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        clientId.placeholder = "Client Id"
        clientSecret.placeholder = "Client secret"
        
        clientId.autocapitalizationType = .None
        clientSecret.autocapitalizationType = .None
        
        clientId.autocorrectionType = .No
        clientSecret.autocorrectionType = .No
        
        clientId.returnKeyType = .Next
        clientSecret.returnKeyType = .Send
        
        clientId.borderStyle = .Line
        clientSecret.borderStyle = .Line
        
        let font = UIFont(name: "Lab-Medium", size: 20)
        
        clientId.font = font
        clientSecret.font = font
        
        button.layer.cornerRadius = 10
        button.setTitle("Submit", forState: .Normal)
        button.backgroundColor = UIColor(red: 1, green: 0.5725490196, blue: 0.1411764705, alpha: 1)
        button.titleLabel?.font = font
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(logo)
        addSubview(button)
        addSubview(clientId)
        addSubview(clientSecret)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = CGRectGetWidth(frame)
        
        logo.frame = CGRectMake(w/2 - 30, 50, 60, 60)
        
        clientId.frame = CGRectMake(40, CGRectGetMaxY(logo.frame) + 20, w - 80, 30)
        clientSecret.frame = CGRectMake(40, CGRectGetMaxY(clientId.frame) + 10, w - 80, 30)
        
        button.frame = CGRectMake(40, CGRectGetMaxY(clientSecret.frame) + 20, w - 80, 40)
    }
    
}

