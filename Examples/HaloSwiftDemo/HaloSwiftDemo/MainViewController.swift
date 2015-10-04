//
//  MainViewController.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 04/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import UIKit
import Halo

class MainViewController: UITableViewController {

    var moduleId: String?
    var instances: [Halo.GeneralContentInstance] = []
    private let cellIdent = "cell"
    private let halo = Halo.Manager.sharedInstance

    init(moduleId: String?) {
        super.init(style: .Plain)
        self.moduleId = moduleId
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Fetching instances")
        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)

        loadData()
    }

    func loadData() -> Void {

        instances.removeAll()

        if let id = moduleId {

            NSLog("Loading module \(id)")

            halo.generalContent.getInstances(id,
                completionHandler: { (result) -> Void in
                    switch result {
                    case .Success(let instances):
                        self.instances.appendContentsOf(instances)
                    case .Failure(let error):
                        NSLog("Error: \(error.localizedDescription)")
                    }

                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })

        } else {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return instances.count
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdent)

        if (cell == nil) {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdent)
            cell?.selectionStyle = .None
        }

        let instance = instances[indexPath.row]
        cell?.textLabel?.text = instance.name

        let dateString = NSDateFormatter.localizedStringFromDate(instance.updatedAt!, dateStyle: .ShortStyle, timeStyle: .ShortStyle)

        cell?.detailTextLabel?.text = "Last update: \(dateString)"

        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let instance = instances[indexPath.row]
        let vc = KeyValueViewController(instance.values)
        vc.title = instance.name

        self.navigationController?.pushViewController(vc, animated: true)

    }

}