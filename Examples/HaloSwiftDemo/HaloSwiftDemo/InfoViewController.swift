//
//  SettingsViewController.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 14/09/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit
import Halo

class InfoViewController: UITableViewController {
    
    let cellIdent = "settingsCell"
    let mgr = Halo.Manager.sharedInstance
    
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
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdent)
        
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: cellIdent)
        }
        
        switch indexPath.row {
        case 0: // Environment
            cell?.textLabel?.text = "Environment"
            
            let backend = NSUserDefaults.standardUserDefaults().stringForKey(Halo.CoreConstants.environmentKey)
            cell?.detailTextLabel?.text = backend
        case 1: // Version
            cell?.textLabel?.text = "App version"
            
            let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
            cell?.detailTextLabel?.text = version
        case 2: // Build
            cell?.textLabel?.text = "Build number"
            
            let version = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
            cell?.detailTextLabel?.text = version
        case 3: // Push token
            cell?.textLabel?.text = "Push token"
            cell?.detailTextLabel?.text = "-"
            if let devices = mgr.user?.devices {
                cell?.detailTextLabel?.text = devices.count > 0 ? devices[0].token : "-"
            }
        default: break
        }
        
        return cell!
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0: // Environment
            let alert = UIAlertController(title: "Select environment", message: "Choose the environment", preferredStyle: .Alert)
            
            let intAction = UIAlertAction(title: "Int", style: .Default, handler: { (_) -> Void in
                self.mgr.environment = .Int
                self.tableView.reloadData()
            })
            
            let qaAction = UIAlertAction(title: "QA", style: .Default, handler: { (_) -> Void in
                self.mgr.environment = .QA
                self.tableView.reloadData()
            })
            
            let stageAction = UIAlertAction(title: "Stage", style: .Default, handler: { (_) -> Void in
                self.mgr.environment = .Stage
                self.tableView.reloadData()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
            
            alert.addAction(intAction)
            alert.addAction(qaAction)
            alert.addAction(stageAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        case 3: // Push token
            let alert = UIAlertController(title: "Push token", message: mgr.user?.devices?[0].token ?? "-", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        default: break
        }
        
    }

    
}