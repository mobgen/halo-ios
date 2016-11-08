//
//  CloudinaryURL.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

public class CloudinaryURL {

    private var url: String
    private var params: [String] = []

    public init(url: String) {
        self.url = url
    }

    public var URL: NSURL {

        if self.url.containsString("cloudinary.com") {
            if let match = self.url.rangeOfString("/upload/") {
                let endUrl = self.url.substringFromIndex(match.endIndex)
                self.url = self.url.stringByReplacingOccurrencesOfString(endUrl, withString: "\(params.joinWithSeparator(","))/\(endUrl)")
            }
        }

        return NSURL(string: self.url)!
    }

    public var absoluteURLString: String {
        return URL.absoluteString ?? ""
    }
    
    public func width(pixels w: Int) -> CloudinaryURL {
        params.append("w_\(w)")
        return self
    }

    public func width(percent w: Float) -> CloudinaryURL {
        params.append("w_\(w)")
        return self
    }

    public func height(pixels w: Int) -> CloudinaryURL {
        params.append("h_\(w)")
        return self
    }

    public func height(percent w: Float) -> CloudinaryURL {
        params.append("h_\(w)")
        return self
    }

    public func crop(mode: ImageCropMode) -> CloudinaryURL {
        params.append("c_\(mode.rawValue)")
        return self
    }

    public func aspectRatio(ratio ar: String) -> CloudinaryURL {
        params.append("ar_\(ar)")
        return self
    }

    public func aspectRatio(percent ar: Float) -> CloudinaryURL {
        params.append("ar_\(ar)")
        return self
    }

    public func gravity(g g: ImageGravityMode) -> CloudinaryURL {
        params.append("g_\(g.rawValue)")
        return self
    }

    public func zoom(percent p: Float) -> CloudinaryURL {
        params.append("z_\(p)")
        return self
    }

    public func xPos(pixels x: Int) -> CloudinaryURL {
        params.append("x_\(x)")
        return self
    }

    public func xPos(percent x: Float) -> CloudinaryURL {
        params.append("x_\(x)")
        return self
    }

    public func yPos(pixels y: Int) -> CloudinaryURL {
        params.append("y_\(y)")
        return self
    }

    public func yPos(percent y: Float) -> CloudinaryURL {
        params.append("y_\(y)")
        return self
    }

    public func quality(percent p: Float) -> CloudinaryURL {
        params.append("q_\(p)")
        return self
    }

    public func radius(pixels px: Int) -> CloudinaryURL {
        params.append("r_\(px)")
        return self
    }

    public func maxRadius() -> CloudinaryURL {
        params.append("r_max")
        return self
    }

    public func rotate(angle a: ImageRotation) -> CloudinaryURL {
        params.append("a_\(a.rawValue)")
        return self
    }

    public func addEffect(effect e: ImageEffect) -> CloudinaryURL {
        params.append("e_\(e.rawValue)")
        return self
    }

    public func opacity(opacity op: Int) -> CloudinaryURL {
        params.append("o_\(op)")
        return self
    }

    public func border(border b: String) -> CloudinaryURL {
        params.append("bo_\(b)")
        return self
    }

    public func backgroundColor(identifier color: String) -> CloudinaryURL {
        params.append("b_\(color)")
        return self
    }

    public func backgroundColor(rgb color: String) -> CloudinaryURL {
        params.append("b_rgb:\(color)")
        return self
    }

    public func overlay(id id: String) -> CloudinaryURL {
        params.append("l_\(id)")
        return self
    }

    public func overlayText(text text: String) -> CloudinaryURL {
        params.append("l_text:\(text)")
        return self
    }

    public func underlay(id id: String) -> CloudinaryURL {
        params.append("u_\(id)")
        return self
    }

    public func defaultImage(id id: String) -> CloudinaryURL {
        params.append("d_\(id)")
        return self
    }

    public func delay(delay delay: Int) ->  CloudinaryURL {
        params.append("dl_\(delay)")
        return self
    }

    public func color(identifier color: String) -> CloudinaryURL {
        params.append("co_\(color)")
        return self
    }

    public func color(rgb color: String) -> CloudinaryURL {
        params.append("co_rgb:\(color)")
        return self
    }

    public func devicePixelRatio(ratio r: Float) -> CloudinaryURL {
        params.append("dpr_\(r)")
        return self
    }

    public func page(page pg: Int) -> CloudinaryURL {
        params.append("pg_\(pg)")
        return self
    }

    public func dpi(dpi dpi: Int) -> CloudinaryURL {
        params.append("dn_\(dpi)")
        return self
    }

    public func addFlags(flags flags: ImageFlag...) -> CloudinaryURL {
        let arg = flags.map { $0.rawValue }.joinWithSeparator(".")
        params.append("fl_\(arg)")
        return self
    }

    public func namedTransformation(name name: String) -> CloudinaryURL {
        params.append("t_\(name)")
        return self
    }
}
