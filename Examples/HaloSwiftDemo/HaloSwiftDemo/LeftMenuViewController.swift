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


class LeftMenuViewController: UITableViewController, Halo.ManagerDelegate {

    var barColor: UIColor?
    var menuColor: UIColor?
    
    var modules: [Halo.Module] = []

    private let halo = Halo.Manager.sharedInstance

    init() {
        super.init(style: .Plain)
        self.halo.delegate = self
        
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HALO Modules"

        var frame = UIScreen.mainScreen().bounds
        frame.size.width = 275
        self.tableView.frame = frame
        self.tableView.backgroundColor = UIColor.mobgenGreen()
        self.tableView.separatorStyle = .None

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.tintColor = UIColor.whiteColor()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Fetching modules", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.refreshControl!.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        
        setupCrittercism()
        setupEnvironment()
    }

    // MARK: Custom setup functions
    
    private func setupCrittercism() {
        Crittercism.enableWithAppID(Config.crittercismAppId)
    }
    
    private func setupEnvironment() {
        var env = NSUserDefaults.standardUserDefaults().stringForKey(Halo.CoreConstants.environmentKey)
        
        if env == nil {
            env = "QA"
            NSUserDefaults.standardUserDefaults().setValue(env, forKey: Halo.CoreConstants.environmentKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        self.halo.environment = HaloEnvironment(rawValue: env!)!
    }
    
    func loadData() {
        NSLog("Loading data")

        self.modules.removeAll()

        self.halo.getModules { [weak self] (result) -> Void in

            if let strongSelf = self {
                
                strongSelf.barColor = nil
                strongSelf.menuColor = nil
                
                switch result {
                case .Success(let modules):
                    strongSelf.modules.appendContentsOf(modules)

                    // Get the color configuration
                    
                    let mods = modules.filter({ (module: Halo.Module) -> Bool in
                        return module.name == "ColorConfiguration"
                    })
                    
                    if let module = mods.first, moduleId = module.internalId {
                        // Get the only instance
                        strongSelf.halo.generalContent.getInstances(moduleId, completionHandler: { (instanceResult) -> Void in
                            switch instanceResult {
                            case .Success(let instance):
                                
                                let dict = instance.first!.values
                                
                                strongSelf.barColor = UIColor(rgba: dict!["ToolbarColor"] as! String)
                                strongSelf.menuColor = UIColor(rgba: dict!["MenuColor"] as! String)
                                strongSelf.setupApp()
                            case .Failure(let error):
                                NSLog("Error: \(error.localizedDescription)")
                            }
                        })
                    }
                    
                    NSLog("Modules loaded: \(strongSelf.modules)")
                case .Failure(let error):
                    NSLog("Error retrieving modules: \(error.localizedDescription)")
                }
                
                strongSelf.tableView.reloadData()
                strongSelf.refreshControl?.endRefreshing()
            }
        }
    }

    func setupApp() {
        
        let navigationBarAppearace = UINavigationBar.appearance()
        let barColor = self.barColor ?? UIColor.mobgenLightGreen()
        let menuColor = self.menuColor ?? UIColor.mobgenGreen()
        
        navigationBarAppearace.barTintColor = barColor
        
        if let container = self.view.window?.rootViewController as? ContainerViewController {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                container.mainView.navigationBar.barTintColor = barColor
            })
        }
        
        self.tableView.backgroundColor = menuColor
        self.view.backgroundColor = menuColor

        self.tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var frame = tableView.frame
        frame.size.height = 55

        let label = UILabel(frame: frame)
        label.textAlignment = .Center
        label.backgroundColor = tableView.backgroundColor

        let attrs = [
            NSFontAttributeName : UIFont(name: "Lab-Medium", size: 35)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]

        switch section {
        case 0:
            label.attributedText = NSAttributedString(string: "MODULES", attributes: attrs)
        case 1:
            label.attributedText = NSAttributedString(string: "ADD-ONS", attributes: attrs)
        case 2:
            label.attributedText = NSAttributedString(string: "OTHER", attributes: attrs)
        default: break
            // Do nothing
        }

        return label
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
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
        finalCell.detailTextLabel?.text = nil

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
        case 2:
            finalCell.textLabel?.text = "App info"
        default: break
        }

        return finalCell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let container = self.parentViewController as! ContainerViewController
        var vc: UIViewController?

        switch indexPath.section {
        case 0:
            let module = self.modules[indexPath.row]
            
            if let name = module.name?.lowercaseString {
            
                switch name {
                case "store locator":
                    vc = StoreLocatorViewController(module: module)
                case "news motorist", "qroffer":
                    vc = NewsListViewController(moduleId: module.internalId)
                default:
                    vc = MainViewController(moduleId: module.internalId)

                }

                vc!.title = name
            }
            
        case 1:
            vc = TagsViewController()
            vc!.title = "Segmentation tags"
        case 2:
            vc = InfoViewController()
            vc!.title = "App info"
        default:
            break
        }

        if let controller = vc {
            container.mainView.popToRootViewControllerAnimated(false)
            container.mainView?.pushViewController(controller, animated: true)
        }

        container.toggleLeftMenu()
    }

    // MARK: ManagerDelegate methods
    
    func setupUser() -> Halo.User {
        let user: Halo.User = Halo.User()
        
        user.email = "test@mobgen.com"
        user.addTag("My custom tag", value: "HELL YEAH!")
        
        return user
    }
    
    func managerDidFinishLaunching() -> Void {
        NSLog("Manager did finish launching")
        self.loadData()
    }
    
}

class MenuCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.textLabel?.textColor = UIColor.whiteColor()
        self.selectionStyle = .None
        self.detailTextLabel?.textColor = UIColor.mobgenLightGray()
        self.backgroundColor = UIColor.clearColor()
    }

    class func cellHeight() -> CGFloat {
        return 55
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
