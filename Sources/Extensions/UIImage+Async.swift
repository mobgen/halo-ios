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

    static func loadFromUrl(_ url: URL, completionHandler handler: @escaping (UIImage?) -> Void) {

        let queue = DispatchQueue.global(qos: .background)

        queue.async { () -> Void in
            if let imageData = try? Data(contentsOf: url) {
                let image = UIImage(data: imageData)
                DispatchQueue.main.async(execute: { () -> Void in
                    handler(image)
                })
            } else {
                handler(nil)
            }
        }
    }
}


extension UIImageView {

    public func setImageWithURL(_ url: URL, completionHandler handler: ((UIImageView) -> Void)? = nil) {
        self.setImageWithURL(url, placeholderImage: nil, completionHandler: handler)
    }

    public func setImageWithURL(_ url: URL, placeholderImage placeholder: UIImage?, completionHandler handler: ((UIImageView) -> Void)? = nil) {

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
