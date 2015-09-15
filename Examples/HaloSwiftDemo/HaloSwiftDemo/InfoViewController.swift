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
            
            let backend = NSUserDefaults.standardUserDefaults().stringForKey(Halo.CoreConstants.environmentKey)
            cell?.detailTextLabel?.text = backend
        default: break
        }
        
        return cell!
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0: // Environment
            let alert = UIAlertController(title: "Select environment", message: "Choose the environment", preferredStyle: .ActionSheet)
            
            let intAction = UIAlertAction(title: "Int", style: .Default, handler: { (_) -> Void in
                self.mgr.environment = .Int
                self.switchEnvironment()
            })
            
            let qaAction = UIAlertAction(title: "QA", style: .Default, handler: { (_) -> Void in
                self.mgr.environment = .QA
                self.switchEnvironment()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
            
            alert.addAction(intAction)
            alert.addAction(qaAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        default: break
        }
        
    }

    func switchEnvironment() {
        self.tableView.reloadData()
        mgr.launch()
        
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
            let vc = window.rootViewController as? ContainerViewController
            vc?.leftMenu.loadData()
        }
    }
    
}