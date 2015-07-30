//
//  SampleViewController.swift
//  HALOSwiftDemo
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import UIKit
import Halo
import Result

class SampleViewController: UITableViewController {
    
    var modules = [HaloModule]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HALO Modules"
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }
    
    func loadData() {
        modules.removeAll()
        
        Manager.sharedInstance.getModules { (result) -> Void in
            switch (result) {
            case .Success(let mod):
                self.modules.extend(mod)
            case .Failure(let err):
                print("Error: \(err.localizedDescription)")
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        
        let finalCell = cell!
        
        finalCell.textLabel?.text = modules[indexPath.row].name
        return finalCell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

