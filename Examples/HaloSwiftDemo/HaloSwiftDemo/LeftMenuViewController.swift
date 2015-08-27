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

enum HaloAddon {
    case Tags
}

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
            case .Failure(_, let error):
                let err = error as NSError
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

        switch section {
        case 0:
            label.attributedText = NSAttributedString(string: "MODULES", attributes: attrs)
        case 1:
            label.attributedText = NSAttributedString(string: "ADD-ONS", attributes: attrs)
        default: break
            // Do nothing
        }

        return label
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return modules.count
        default:
            return 1
        }

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

        switch indexPath.section {
        case 0:
            let module = modules[indexPath.row]
            finalCell.textLabel?.text = module.name

            if let date = module.lastUpdate {
                let dateString = NSDateFormatter.localizedStringFromDate(date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
                finalCell.detailTextLabel?.text = "Last updated: \(dateString)"
            }
        case 1:
            finalCell.textLabel?.text = "Segmentation Tags"
        default: break
        }

        return finalCell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let container = self.parentViewController as! ContainerViewController

        switch indexPath.section {
        case 0:
            delegate?.didSelectModule(self.modules[indexPath.row])
        case 1:
            let vc = TagsViewController()
            vc.title = "Segmentation tags"

            container.mainView?.pushViewController(vc, animated: true)
        default:
            break
        }

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

    class func cellHeight() -> CGFloat {
        return 55
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
