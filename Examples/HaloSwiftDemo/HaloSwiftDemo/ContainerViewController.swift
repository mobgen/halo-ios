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

        self.view.backgroundColor = UIColor.whiteColor()

        leftMenu = LeftMenuViewController()

        let vc = MainViewController()
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: "test")

        mainView = UINavigationController(rootViewController: vc)

        self.view.addSubview(self.leftMenu.view)
        self.view.addSubview(self.mainView.view)

    }

    func test() {
        let x = CGRectGetMinX(self.mainView.view.frame)
        let sign: CGFloat = x < 275 ? 1 : -1

        let offFrame = CGRectOffset(self.mainView.view.frame, sign * 275, 0)

        if (x == 0) {
            //Create the UIImage
            self.screenshot = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(true)
            self.screenshot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "test"))
            self.mainView.view.addSubview(self.screenshot)
            self.mainView.view.bringSubviewToFront(self.screenshot)
            UIApplication.sharedApplication().statusBarHidden = true
        }

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.mainView.view.frame = offFrame
        }) { (done) -> Void in
            if (sign < 0) {
                UIApplication.sharedApplication().statusBarHidden = false
                self.screenshot.removeFromSuperview()
            }
        }

    }

}