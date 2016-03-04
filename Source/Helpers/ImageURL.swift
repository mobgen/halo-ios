//
//  File.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

public class ImageURL {
    
    private var url: String
    private var params: [String] = []
    
    public init(url: String) {
        self.url = url
    }
    
    public var URL: NSURL {
        
        if let match = self.url.rangeOfString("/upload/") {
            let endUrl = self.url.substringFromIndex(match.endIndex.successor())
            self.url = self.url.stringByReplacingOccurrencesOfString(endUrl, withString: "\(params.joinWithSeparator(","))/\(endUrl)")
        }
        
        return NSURL(string: self.url)!
    }
    
    public func width(pixels w: Int) -> ImageURL {
        params.append("w_\(w)")
        return self
    }
    
    public func width(percent w: Float) -> ImageURL {
        params.append("w_\(w)")
        return self
    }
    
    public func height(pixels w: Int) -> ImageURL {
        params.append("h_\(w)")
        return self
    }
    
    public func height(percent w: Float) -> ImageURL {
        params.append("h_\(w)")
        return self
    }
    
    public func crop(mode: CropMode) -> ImageURL {
        params.append("c_\(mode.rawValue)")
        return self
    }
    
    public func aspectRatio(ratio ar: String) -> ImageURL {
        params.append("ar_\(ar)")
        return self
    }
    
    public func aspectRatio(percent ar: Float) -> ImageURL {
        params.append("ar_\(ar)")
        return self
    }
    
    public func gravity(g: GravityMode) -> ImageURL {
        params.append("g_\(g.rawValue)")
        return self
    }
    
    public func zoom(percent: Float) -> ImageURL {
        params.append("z_\(percent)")
        return self
    }
    
    public func xPos(pixels x: Int) -> ImageURL {
        params.append("x_\(x)")
        return self
    }
    
    public func xPos(percent x: Float) -> ImageURL {
        params.append("x_\(x)")
        return self
    }
    
    public func yPos(pixels y: Int) -> ImageURL {
        params.append("y_\(y)")
        return self
    }
    
    public func yPos(percent y: Float) -> ImageURL {
        params.append("y_\(y)")
        return self
    }
    
    public func quality(percent: Float) -> ImageURL {
        params.append("q_\(percent)")
        return self
    }
    
    public func radius(pixels: Int) -> ImageURL {
        params.append("r_\(pixels)")
        return self
    }
    
    public func maxRadius() -> ImageURL {
        params.append("r_max")
        return self
    }
    
    public func rotate(a: Rotation) -> ImageURL {
        params.append("a_\(a.rawValue)")
        return self
    }
    
    
}
