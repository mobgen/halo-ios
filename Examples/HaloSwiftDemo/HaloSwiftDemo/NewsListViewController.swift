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

class Article: NSObject {
    
    var title: String?
    var date: NSDate?
    var url: String?
    var body: String?
    var thumbnailURL: NSURL?
    var imageURL: NSURL?
    
    init(instance: Halo.GeneralContentInstance) {
        
        let dict = instance.values!
        
        self.title = dict["title"] as? String
        
        if let date = dict["date"] as? NSNumber {
            self.date = NSDate(timeIntervalSince1970: date.doubleValue/1000)
        }
        
        self.body = dict["article"] as? String
        self.url = dict["url"] as? String

        if let image = dict["image"] as? String {
            self.imageURL = NSURL(string: image)
        }
        
        if let thumb = dict["thumbnail"] as? String {
            self.thumbnailURL = NSURL(string: thumb)
        }
        
        super.init()
        
    }
}

class NewsListViewController: UITableViewController {
 
    let halo = Halo.Manager.sharedInstance
    let cellIdent = "articleCell"
    var moduleId: String?
    var news: [Article]?
    
    init(module: Halo.Module) {
        self.moduleId = module.internalId
        super.init(style: .Plain)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        halo.generalContent.getInstances(self.moduleId!) { (result) -> Void in
            switch result {
            case .Success(let instances):
                self.news = []
                for inst in instances {
                    self.news?.append(Article(instance: inst))
                }
                self.tableView.reloadData()
            case .Failure(_, let error):
                let err = error as NSError
                print("Error: \(err.localizedDescription)")
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
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdent)
        
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdent)
        }
        
        if let newsArray = self.news {
            let article = newsArray[indexPath.row]
            cell?.textLabel?.text = article.title
            cell?.detailTextLabel?.text =  NSDateFormatter.localizedStringFromDate(article.date!, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
            if let imgData = NSData(contentsOfURL: article.thumbnailURL!) {
                cell?.imageView?.image = UIImage(data: imgData)
            }
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let news = self.news {
            let article = news[indexPath.row]
        
            let vc = ArticleViewController(article: article)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}