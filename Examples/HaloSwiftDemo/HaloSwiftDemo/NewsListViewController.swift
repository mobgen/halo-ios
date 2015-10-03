//
//  NewsListViewController.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 11/09/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit
import Halo
import AlamofireImage

class Article: NSObject {
    
    var moduleId: String?
    var instanceId: String?
    var title: String?
    var summary: String?
    var date: NSDate?
    var content: String?
    var thumbnailURL: NSURL?
    var imageURL: NSURL?
    var QRURL: NSURL?
    
    init(instance: Halo.GeneralContentInstance) {
        
        let dict = instance.values!
        
        self.moduleId = instance.moduleId
        self.instanceId = instance.id
        
        self.title = dict["Title"] as? String
        
        if let date = dict["Date"] as? NSNumber {
            self.date = NSDate(timeIntervalSince1970: date.doubleValue/1000)
        }
        
        self.summary = dict["Summary"] as? String
        self.content = dict["ContentHtml"] as? String

        if let image = dict["Image"] as? String {
            self.imageURL = NSURL(string: image)
        }
        
        if let thumb = dict["Thumbnail"] as? String {
            self.thumbnailURL = NSURL(string: thumb)
        }
        
        if let qr = dict["QRImage"] as? String {
            self.QRURL = NSURL(string: qr)
        }
        
        super.init()
    }
}

class ArticleCell: UITableViewCell {
    
    var summaryLabel: UILabel?

    init(reuseIdentifier: String?) {
        
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont(name: "Lab-Medium", size: 20)
        
        imageView?.clipsToBounds = true
        imageView?.autoresizingMask = .None
        imageView?.contentMode = .ScaleAspectFill

        detailTextLabel?.font = UIFont(name: "Lab-Medium", size: 16)
        
        summaryLabel = UILabel(frame: CGRectZero)
        summaryLabel?.numberOfLines = 2
        summaryLabel?.font = UIFont(name: "Lab-Medium", size: 14)
        
        contentView.addSubview(summaryLabel!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let x = CGRectGetMinX(self.textLabel!.frame)
        let w = CGRectGetWidth(self.textLabel!.frame)
        
        var frame = textLabel?.frame
        frame?.origin.y = 10
        
        textLabel?.frame = frame!
        
        frame = detailTextLabel?.frame
        frame?.origin.y = CGRectGetMaxY(textLabel!.frame)
        
        detailTextLabel?.frame = frame!
        
        summaryLabel?.frame = CGRectMake(x, CGRectGetMaxY((self.detailTextLabel?.frame)!) + 5, w, 28)
        
    }
    
}

class NewsListViewController: UITableViewController {
 
    let halo = Halo.Manager.sharedInstance
    let cellIdent = "articleCell"
    var moduleId: String?
    var news: [Article]?
    
    init(moduleId: String?) {
        super.init(style: .Plain)
    
        self.moduleId = moduleId
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Fetching news")
        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleSilentNotification:", name: "generalcontent", object: nil)
        self.edgesForExtendedLayout = .None
        tableView.contentInset = UIEdgeInsetsMake(22, 0, 0, 0)
        self.loadData()
        
    }
    
    func loadData() {
        if let id = self.moduleId {
            halo.generalContent.getInstances(id) { (result) -> Void in
                switch result {
                case .Success(let instances):
                    self.news = []
                    for inst in instances {
                        self.news?.append(Article(instance: inst))
                    }
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                case .Failure(let error):
                    NSLog("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func handleSilentNotification(notification: NSNotification) {
        
        if let info = notification.userInfo {
            if let module = info["module"] as? String, moduleId = info["moduleId"] as? String, ownModuleId = self.moduleId {
                if module == "generalcontent" && moduleId == ownModuleId {
                    NSLog("Reloading!!")
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    // MARK: UITableView delegate methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdent)
        var articleCell: ArticleCell?
        
        if let cell2 = cell as? ArticleCell {
            articleCell = cell2
        } else {
            articleCell = ArticleCell(reuseIdentifier: cellIdent)
        }
        
        if let newsArray = self.news {
            let article = newsArray[indexPath.row]
            articleCell?.textLabel?.text = article.title
            articleCell?.detailTextLabel?.text =  NSDateFormatter.localizedStringFromDate(article.date!, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
            articleCell?.summaryLabel?.text = article.summary
            
            if let thumbnail = article.thumbnailURL {
                articleCell?.imageView?.af_setImageWithURL(thumbnail, placeholderImage: UIImage(named: "placeholder"))
            }
            
        }
        
        return articleCell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let news = self.news {
            let article = news[indexPath.row]
            
            let vc = ArticleViewController(articleId: article.instanceId!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88;
    }
    
}