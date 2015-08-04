//
//  SampleViewController.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import UIKit
import Halo
import Alamofire

class LeftMenuViewController: UITableViewController {

    var modules = [HaloModule]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HALO Modules"

        var frame = self.view.frame
        frame.size.width = 275
        self.view.frame = frame

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Fetching modules")
        self.refreshControl!.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)

        loadData()
    }

    func loadData() {
        modules.removeAll()
        
        Manager.sharedInstance.getModules { (result) -> Void in
            switch (result) {
            case .Success(let mod):
                self.modules.extend(mod)
            case .Failure(_, let err):
                print("Error: \(err.localizedDescription)")
            }

            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
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
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        }
        
        let finalCell = cell!

        let module = modules[indexPath.row]

        finalCell.textLabel?.text = module.name

        if let name = module.moduleType?.name {
            let dateString = NSDateFormatter.localizedStringFromDate(module.lastUpdate!, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
            finalCell.detailTextLabel?.text = "\(name) | Last updated: \(dateString)"
        }

        return finalCell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

