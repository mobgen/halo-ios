//
//  SettingsViewController.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 14/09/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    
    let cellIdent = "settingsCell"
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(style: .Plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdent)
        
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: cellIdent)
        }
        
        switch indexPath.row {
        case 0: // Environment
            cell?.textLabel?.text = "Environment"
            
            let backend = NSUserDefaults.standardUserDefaults().stringForKey(Constants.BackendKey)
            cell?.detailTextLabel?.text = backend
        default: break
        }
        
        return cell!
        
    }
    
}