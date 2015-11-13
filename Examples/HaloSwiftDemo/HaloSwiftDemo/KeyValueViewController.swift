//
//  KeyValueViewController.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 05/08/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit
import Halo

class ColorCell: UITableViewCell {

    var square: UIButton

    init(color: UIColor, reuseIdentifier: String) {
        square = UIButton(type: .Custom)
        square.backgroundColor = color
        square.enabled = false

        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(square)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let w = CGRectGetWidth(self.frame)

        self.square.frame = CGRectMake(w - 45, 7, 40, 40)
    }
}

class ImageCell: UITableViewCell {

    var imagePreview: UIImageView

    init(imageUrl: String, reuseIdentifier: String) {

        imagePreview = UIImageView(frame: CGRectZero)
        imagePreview.contentMode = .ScaleAspectFit

        var url: NSURL

        let regex = try! NSRegularExpression(pattern: "v=(.+?)(?=$|&)", options: .CaseInsensitive)

        /// Check for a match against Youtube-like urls
        if let match = regex.firstMatchInString(imageUrl, options: .WithoutAnchoringBounds, range: NSMakeRange(0, imageUrl.characters.count)) {
            let videoId = (imageUrl as NSString).substringWithRange(match.rangeAtIndex(1))
            url = NSURL(string: "http://img.youtube.com/vi/\(videoId)/default.jpg")!
        } else {
            url = NSURL(string: imageUrl)!
        }

        imagePreview.af_setImageWithURL(url)

        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(imagePreview)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let w = CGRectGetWidth(self.frame)
        let h = CGRectGetHeight(self.frame)

        self.imagePreview.frame = CGRectMake(w - 105, 0, 100, h)
    }


}

class KeyValueViewController: UITableViewController {

    let halo = Halo.Manager.sharedInstance
    var values: [(String, String?)] = []
    private let cellIdent = "cellId"
    private var instanceId: String = ""

    init(instanceId: String) {
        self.instanceId = instanceId
        super.init(style: .Plain)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadData() -> Void {

        self.refreshControl?.beginRefreshing()
        self.values.removeAll()

        halo.generalContent.getInstance(instanceId: self.instanceId) { (result) -> Void in
            switch result {
            case .Success(let instance):
                for (k, v) in instance.values {
                    self.values.append((k, String(v)))
                }
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            case .Failure(let error):
                NSLog("Error: \(error.localizedDescription)")
            }
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Fetching values")
        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)

        loadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let tuple = values[indexPath.row]

        let title = tuple.0
        let value = tuple.1!

        var cell: UITableViewCell?

        if value.hasPrefix("#") {
            cell = tableView.dequeueReusableCellWithIdentifier("colorCell")

            if cell == nil {
                cell = ColorCell(color: UIColor(rgba: value), reuseIdentifier: "colorCell")
            }

        } else if value.hasPrefix("http") {

            cell = tableView.dequeueReusableCellWithIdentifier("imageCell")

            if cell == nil {
                cell = ImageCell(imageUrl: value, reuseIdentifier: "imageCell")
            }

        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdent)

            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdent)
            }

            cell?.detailTextLabel?.text = value
        }

        cell?.textLabel?.text = title
        cell?.selectionStyle = .None

        return cell!

    }

}