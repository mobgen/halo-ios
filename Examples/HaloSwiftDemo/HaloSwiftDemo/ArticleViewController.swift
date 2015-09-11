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
    var articleBody: UITextView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView(frame: CGRectZero)
        articleTitle = UILabel(frame: CGRectZero)
        
        articleTitle?.font = UIFont(name: "Lab-Medium", size: 20)
        articleTitle?.numberOfLines = 0
        
        articleDate = UILabel(frame: CGRectZero)
        articleBody = UITextView(frame: CGRectZero)
        
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
            rect = (text as NSString).boundingRectWithSize(CGSizeMake(w - 70, CGFloat.max), options: NSStringDrawingOptions.UsesFontLeading, attributes: [NSFontAttributeName: UIFont(name: "Lab-Medium", size: 20)!], context: nil)
        }
        
        self.articleTitle?.frame = CGRectMake(20, CGRectGetMaxY((self.imageView?.frame)!) + 20, w - 70, rect?.size.height ?? 20)
        
        
        if let text = self.articleBody?.text {
            rect = (text as NSString).boundingRectWithSize(CGSizeMake(w - 40, CGFloat.max), options: NSStringDrawingOptions.UsesFontLeading, attributes: nil, context: nil)
        }
    }

}

class ArticleViewController: UIViewController {
 
    init(article: Article) {
        super.init(nibName: nil, bundle: nil)
        
        let customView: ArticleView = self.view as! ArticleView
        
        self.title = article.title
        
        customView.imageView?.image = UIImage(data: NSData(contentsOfURL: article.imageURL!)!)
        customView.articleTitle?.text = article.title
        
        customView.layoutIfNeeded()
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
}
