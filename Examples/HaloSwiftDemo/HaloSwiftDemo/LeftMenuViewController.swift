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

protocol LeftMenuDelegate {
    func didSelectModule(module: Halo.Module) -> Void
}

class LeftMenuViewController: UITableViewController {

    var modules: [Halo.Module] = []
    var delegate: LeftMenuDelegate?
    private let halo = Halo.Manager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HALO Modules"

        var frame = self.view.frame
        frame.size.width = 275
        self.tableView.frame = frame
        self.tableView.backgroundColor = UIColor.mobgenGreen()
        self.tableView.separatorStyle = .None

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.tintColor = UIColor.whiteColor()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Fetching modules", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.refreshControl!.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)

        loadData()
    }

    func loadData() {
        modules.removeAll()

        halo.getModules { (result) -> Void in

            switch result {
            case .Success(let modules):
                self.modules.extend(modules)
            case .Failure(_, let err):
                print("Error retrieving modules: \(err.localizedDescription)")
            }

            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var frame = tableView.frame
        frame.size.height = 55

        let label = UILabel(frame: frame)
        label.textAlignment = .Center
        label.backgroundColor = UIColor.mobgenGreen()

        let attrs = [
            NSFontAttributeName : UIFont(name: "Lab-Medium", size: 35)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]

        label.attributedText = NSAttributedString(string: "MODULES", attributes: attrs)

        return label
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return MenuCell.cellHeight()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? MenuCell
        
        if cell == nil {
            cell = MenuCell(style: .Subtitle, reuseIdentifier: "cell")
        }
        
        let finalCell = cell!

        let module = modules[indexPath.row]

        finalCell.textLabel?.text = module.name

        if let date = module.lastUpdate {
            let dateString = NSDateFormatter.localizedStringFromDate(date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
            finalCell.detailTextLabel?.text = "Last updated: \(dateString)"
        }

        return finalCell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectModule(self.modules[indexPath.row])
        let container = self.parentViewController as! ContainerViewController
        container.toggleLeftMenu()
    }

}

class MenuCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.textLabel?.textColor = UIColor.whiteColor()
        self.selectionStyle = .None
        self.detailTextLabel?.textColor = UIColor.mobgenLightGray()
        self.backgroundColor = UIColor.mobgenGreen()
    }

    static func cellHeight() -> CGFloat {
        return 55
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



}

