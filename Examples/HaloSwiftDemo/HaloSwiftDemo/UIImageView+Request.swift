//
//  UIImageView+Request.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 14/09/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    public func imageFromUrl(url: NSURL, placeholder: UIImage? = nil) {
        self.image = placeholder ?? UIImage(named: "placeholder")
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            self.image = UIImage(data: data!)
        }
        
    }
}