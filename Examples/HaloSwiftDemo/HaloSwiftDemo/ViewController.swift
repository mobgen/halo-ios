//
//  ViewController.swift
//  MoMOSSwiftDemo
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import UIKit
import HALOCore
import HALONetworking

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Start HALO
        HALOManager.shared.launch()
        
        let net:HALONetworking = HALOManager.shared.getModule("networking") as! HALONetworking
        
        net.authenticate()
        
        view.backgroundColor = UIColor.redColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

