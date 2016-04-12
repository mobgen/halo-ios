//
//  ImageURL.swift
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

        if self.url.containsString("cloudinary.com") {
            if let match = self.url.rangeOfString("/upload/") {
                let endUrl = self.url.substringFromIndex(match.endIndex.successor())
                self.url = self.url.stringByReplacingOccurrencesOfString(endUrl, withString: "\(params.joinWithSeparator(","))/\(endUrl)")
            }
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
    
    public func crop(mode: ImageCropMode) -> ImageURL {
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
    
    public func gravity(g: ImageGravityMode) -> ImageURL {
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
    
    public func rotate(a: ImageRotation) -> ImageURL {
        params.append("a_\(a.rawValue)")
        return self
    }

    public func addEffect(e: ImageEffect) -> ImageURL {
        params.append("e_\(e.rawValue)")
        return self
    }

    public func addEfects(effects: [ImageEffect]) -> ImageURL {
        let _ = effects.map { self.addEffect($0) }
        return self
    }

    public func opacity(opacity: Int) -> ImageURL {
        params.append("o_\(opacity)")
        return self
    }

    public func border(border: String) -> ImageURL {
        params.append("bo_\(border)")
        return self
    }

    public func backgroundColor(identifier color: String) -> ImageURL {
        params.append("b_\(color)")
        return self
    }

    public func backgroundColor(rgb color: String) -> ImageURL {
        params.append("b_\(color)")
        return self
    }
    
    public func overlay(id: String) -> ImageURL {
        params.append("l_\(id)")
        return self
    }

    public func overlayText(text: String) -> ImageURL {
        params.append("l_text:\(text)")
        return self
    }

    public func underlay(id: String) -> ImageURL {
        params.append("u_\(id)")
        return self
    }

    public func defaultImage(id: String) -> ImageURL {
        params.append("d_\(id)")
        return self
    }

    public func delay(delay: Int) ->  ImageURL {
        params.append("dl_\(delay)")
        return self
    }

    public func color(identifier color: String) -> ImageURL {
        params.append("co_\(color)")
        return self
    }

    public func color(rgb color: String) -> ImageURL {
        params.append("co_rgb:\(color)")
        return self
    }

    public func devicePixelRatio(ratio: Float) -> ImageURL {
        params.append("dpr_\(ratio)")
        return self
    }

    public func page(page: Int) -> ImageURL {
        params.append("pg_\(page)")
        return self
    }

    public func dpi(dpi: Int) -> ImageURL {
        params.append("dn_\(dpi)")
        return self
    }

    public func addFlags(flags: [ImageFlag]) -> ImageURL {
        let arg = flags.map({ $0.rawValue }).joinWithSeparator(".")
        params.append("fl_\(arg)")
        return self
    }

    public func namedTransformation(name: String) -> ImageURL {
        params.append("t_\(name)")
        return self
    }
}
