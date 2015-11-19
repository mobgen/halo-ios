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

class UrlCell: UITableViewCell {

    var imagePreview: UIImageView
    var urlString: String = ""

    init(urlString: String, reuseIdentifier: String) {
        imagePreview = UIImageView(frame: CGRectZero)
        
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)
        
        self.urlString = urlString
        self.contentView.addSubview(imagePreview)
        self.imagePreview.contentMode = .ScaleAspectFit

        var url: NSURL?
        
        let range = NSMakeRange(0, urlString.characters.count)
        var regex = try! NSRegularExpression(pattern: "youtube\\.com|youtu\\.be", options: .CaseInsensitive)
        
        if let _ = regex.firstMatchInString(urlString, options: .WithoutAnchoringBounds, range: range) {
            // It's a youtube link
            
            regex = try! NSRegularExpression(pattern: "youtu\\.be/(.+)|v=(.+?)(?=$|&)", options: .CaseInsensitive)
            
            /// Check for a match against Youtube-like urls
            if let match = regex.firstMatchInString(urlString, options: .WithoutAnchoringBounds, range: range) {
                let videoId = (urlString as NSString).substringWithRange(match.rangeAtIndex(1))
                url = NSURL(string: "http://img.youtube.com/vi/\(videoId)/default.jpg")!
                
                let recognizer = UITapGestureRecognizer(target: self, action: "showYoutube")
                recognizer.numberOfTapsRequired = 1
                self.imagePreview.userInteractionEnabled = true
                self.imagePreview.addGestureRecognizer(recognizer)
                
            }
        } else {
            // Check if it's an image
            regex = try! NSRegularExpression(pattern: "jpg|jpeg|png|gif", options: .CaseInsensitive)
            
            if let _ = regex.firstMatchInString(urlString, options: .WithoutAnchoringBounds, range: range) {
                url = NSURL(string: urlString)!
            }
        }

        if let imageUrl = url {
            self.imagePreview.af_setImageWithURL(imageUrl)
        } else {
            self.imagePreview.hidden = true
            self.detailTextLabel?.text = urlString
        }
    }

    func showYoutube() -> Void {
        UIApplication.sharedApplication().openURL(NSURL(string: self.urlString)!)
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
        super.init(style: .Plain)
        self.instanceId = instanceId
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
                cell = UrlCell(urlString: value, reuseIdentifier: "imageCell")
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