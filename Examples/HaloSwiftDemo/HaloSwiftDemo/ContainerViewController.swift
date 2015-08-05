//
//  ModuleListTableViewController.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 30/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import UIKit

public class ContainerViewController: UIViewController {

    var leftMenu: LeftMenuViewController!
    var mainView: UINavigationController!
    var screenshot: UIView!

    let menuWidth: CGFloat = 275

    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        leftMenu = LeftMenuViewController()

        self.view.backgroundColor = UIColor.mobgenGreen()

        let vc = MainViewController()
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: "toggleLeftMenu")

        leftMenu.delegate = vc

        mainView = UINavigationController(rootViewController: vc)

        self.view.addSubview(self.leftMenu.view)
        self.view.addSubview(self.mainView.view)

        self.addChildViewController(self.leftMenu)
        self.addChildViewController(self.mainView)

        self.leftMenu.didMoveToParentViewController(self)
        self.mainView.didMoveToParentViewController(self)

        mainView.view.layer.shadowOpacity = 0.8

    }

    func toggleLeftMenu() -> Void {
        let x = CGRectGetMinX(self.mainView.view.frame)
        let sign: CGFloat = x < menuWidth ? 1 : -1

        let offFrame = CGRectOffset(self.mainView.view.frame, sign * menuWidth, 0)

        if (x == 0) {
            // Create the screenshot
            self.screenshot = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
            self.screenshot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toggleLeftMenu"))
            self.mainView.view.addSubview(self.screenshot)
            self.mainView.view.bringSubviewToFront(self.screenshot)
            UIApplication.sharedApplication().statusBarHidden = true
        }

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.mainView.view.frame = offFrame
        }) { (done) -> Void in
            if (done && x > 0) {
                UIApplication.sharedApplication().statusBarHidden = false
                /// Weird hack to avoid the view jumping after setting the status bar visible again
                self.screenshot.performSelector("removeFromSuperview", withObject: nil, afterDelay: 0)
            }
        }

    }

}