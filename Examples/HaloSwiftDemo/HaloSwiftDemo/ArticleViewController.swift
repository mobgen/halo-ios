//
//  ArticleViewController.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 11/09/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit

class ArticleView: UIView {

    var imageView: UIImageView?
    var articleTitle: UILabel?
    var articleDate: UILabel?
    var articleBody: UIWebView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView(frame: CGRectZero)
        articleTitle = UILabel(frame: CGRectZero)
        
        articleTitle?.font = UIFont(name: "Lab-Medium", size: 25)
        articleTitle?.numberOfLines = 0
        articleTitle?.lineBreakMode = .ByWordWrapping
        
        articleDate = UILabel(frame: CGRectZero)
        articleDate?.font = UIFont(name: "Lab-Medium", size: 18)
        
        articleBody = UIWebView(frame: CGRectZero)
        articleBody?.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(imageView!)
        self.addSubview(articleTitle!)
        self.addSubview(articleDate!)
        self.addSubview(articleBody!)
        
        self.backgroundColor = UIColor.whiteColor()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = CGRectGetWidth(self.frame)
        
        self.imageView?.frame = CGRectMake(0, 44, w, 200)
        
        var rect: CGRect?
        
        if let text = self.articleTitle?.text {
            rect = (text as NSString).boundingRectWithSize(CGSizeMake(w - 40, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: (self.articleTitle?.font)!], context: nil)
        }
        
        self.articleTitle?.frame = CGRectMake(20, CGRectGetMaxY(self.imageView!.frame) + 20, w - 40, rect?.height ?? 20)
        self.articleDate?.frame = CGRectMake(20, CGRectGetMaxY(self.articleTitle!.frame) + 5, w - 40, 18)
        
        let h = CGRectGetHeight(self.frame)
        let minY = CGRectGetMaxY(self.articleDate!.frame) + 10
        
        self.articleBody?.frame = CGRectMake(20, minY, w - 40, h - minY - 10)
    
    }

}

class ArticleViewController: UIViewController, UIWebViewDelegate {
 
    init(article: Article) {
        super.init(nibName: nil, bundle: nil)
        
        let customView: ArticleView = self.view as! ArticleView
        
        self.title = article.title
        
        customView.imageView?.imageFromUrl(article.imageURL!)
        customView.articleTitle?.text = article.title
        
        customView.articleDate?.text = NSDateFormatter.localizedStringFromDate(article.date!, dateStyle: .MediumStyle, timeStyle: .MediumStyle)
        
        let htmlstr = "<style>body { font-family:helvetica; font-size: small; margin: 0; text-align: justify; }</style>\(article.content!)"
        
        customView.articleBody?.loadHTMLString(htmlstr, baseURL: nil)
        customView.articleBody?.delegate = self
        
        print(htmlstr)
        
        customView.setNeedsLayout()
    }

    override func loadView() {
        self.view = ArticleView(frame: UIScreen.mainScreen().bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        
        return true
    }
}
