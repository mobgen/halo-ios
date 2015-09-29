//
//  ModuleListTableViewController.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 30/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

import UIKit
import Halo

public class ContainerViewController: UIViewController {

    let halo = Halo.Manager.sharedInstance
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
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let leftEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "showMenu:")
        leftEdgeGesture.edges = .Left

        let rightEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "hideMenu:")
        rightEdgeGesture.edges = .Right

        self.view.window?.addGestureRecognizer(rightEdgeGesture)
        self.view.window?.addGestureRecognizer(leftEdgeGesture)

    }
    
    func toggleLeftMenu() -> Void {
        let x = CGRectGetMinX(self.mainView.view.frame)
        let sign: CGFloat = x < menuWidth ? 1 : -1

        let offFrame = CGRectOffset(self.mainView.view.frame, sign * menuWidth, 0)

        if (x == 0) {
            // Create the screenshot
            self.screenshot = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
            //self.screenshot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toggleLeftMenu"))
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
    
    func showMenu(recognizer: UIScreenEdgePanGestureRecognizer) {
        let x = recognizer.translationInView(self.view).x

        if (recognizer.state == .Began) {
            // Create the screenshot
            self.screenshot = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
            self.screenshot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toggleLeftMenu"))
            self.mainView.view.addSubview(self.screenshot)
            self.mainView.view.bringSubviewToFront(self.screenshot)
            UIApplication.sharedApplication().statusBarHidden = true
        }

        if x >= 0 && x <= menuWidth {

            var frame = self.mainView.view.frame
            frame.origin.x = x

            self.mainView.view.frame = frame

        }

        if (recognizer.state == .Ended) {
            var frame = self.mainView.view.frame

            if x > menuWidth/2 {
                frame.origin.x = menuWidth
            } else {
                frame.origin.x = 0
            }

            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.mainView.view.frame = frame
            })
        }
    }


    func hideMenu(recognizer: UIScreenEdgePanGestureRecognizer) {

        let x = CGRectGetMinX(self.mainView.view.frame)
        let newOrigin = CGRectGetMaxX(self.view.frame) + recognizer.translationInView(self.view).x

        if (recognizer.state == .Began || recognizer.state == .Changed) && x > 0 && newOrigin < menuWidth {

            var frame = self.mainView.view.frame
            frame.origin.x = newOrigin > 0 ? newOrigin : 0

            self.mainView.view.frame = frame
        }

        if (recognizer.state == .Ended) {
            var frame = self.mainView.view.frame

            if newOrigin > menuWidth/2 {
                frame.origin.x = menuWidth
            } else {
                frame.origin.x = 0
            }

            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.mainView.view.frame = frame
                }, completion: { (done) -> Void in
                    if done && CGRectGetMinX(self.mainView.view.frame) == 0 {
                        UIApplication.sharedApplication().statusBarHidden = false
                        /// Weird hack to avoid the view jumping after setting the status bar visible again
                        self.screenshot.performSelector("removeFromSuperview", withObject: nil, afterDelay: 0)
                    }
            })

        }

    }

}