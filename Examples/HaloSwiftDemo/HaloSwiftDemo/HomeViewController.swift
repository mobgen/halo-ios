//
//  HomeViewController.swift
//  HaloSwiftDemo
//
//  Created by Borja on 04/10/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit

class HomeView: UIView {

    var imageView: UIImageView

    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRectZero)

        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let w = CGRectGetWidth(self.frame)
        let h = CGRectGetHeight(self.frame)

        imageView.frame = CGRectMake(w/4, h/4, w/2, w/2)
    }


}

class HomeViewController: UIViewController {

    override func loadView() {
        self.view = HomeView(frame: UIScreen.mainScreen().bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let customView = self.view as! HomeView

        customView.imageView.image = UIImage(named: "Halo")

        self.title = "HALO"
    }

}