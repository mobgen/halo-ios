//
//  UIImage+Async.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 15/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    static func loadFromUrl(url: NSURL, completionHandler handler: (UIImage?) -> Void) {

        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

        dispatch_async(queue) { () -> Void in
            if let imageData = NSData(contentsOfURL: url) {
                let image = UIImage(data: imageData)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    handler(image)
                })
            } else {
                handler(nil)
            }
        }
    }
}


extension UIImageView {

    public func setImageWithURL(url: NSURL, completionHandler handler: ((UIImageView) -> Void)? = nil) {
        self.setImageWithURL(url, placeholderImage: nil, completionHandler: handler)
    }

    public func setImageWithURL(url: NSURL, placeholderImage placeholder: UIImage?, completionHandler handler: ((UIImageView) -> Void)? = nil) {

        if let p = placeholder {
            self.image = p
        }

        UIImage.loadFromUrl(url) { (image) -> Void in
            if let img = image {
                self.image = img
            }
            handler?(self)
        }

    }

}
