//
//  ModuleListTableViewController.swift
//  HALOSwiftDemo
//
//  Created by Borja Santos-Díez on 30/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import UIKit

public class ModuleListTableViewController: UITableViewController {
    
    let cellIdent = "cell"
    var modules:[String]?
    
    init(modules mod:[String]?) {
        super.init(style: .Plain)
        modules = mod
        self.title = "Modules"
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Table view methods
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules?.count ?? 0
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
        
        if let _ = cell {
        } else {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdent)
        }
        
        cell?.textLabel?.text = modules![indexPath.row]
        return cell!
    }
    
}