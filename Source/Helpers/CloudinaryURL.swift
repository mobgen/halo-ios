//
//  CloudinaryURL.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

open class CloudinaryURL {

    fileprivate var url: String
    fileprivate var params: [String] = []

    public init(url: String) {
        self.url = url
    }

    open var URL: Foundation.URL {

        if self.url.contains("cloudinary.com") {
            if let match = self.url.range(of: "/upload/") {
                let endUrl = self.url.substring(from: match.upperBound)
                self.url = self.url.replacingOccurrences(of: endUrl, with: "\(params.joined(separator: ","))/\(endUrl)")
            }
        }

        return Foundation.URL(string: self.url)!
    }

    open var absoluteURLString: String {
        return URL.absoluteString
    }
    
    open func width(pixels w: Int) -> CloudinaryURL {
        params.append("w_\(w)")
        return self
    }

    open func width(percent w: Float) -> CloudinaryURL {
        params.append("w_\(w)")
        return self
    }

    open func height(pixels w: Int) -> CloudinaryURL {
        params.append("h_\(w)")
        return self
    }

    open func height(percent w: Float) -> CloudinaryURL {
        params.append("h_\(w)")
        return self
    }

    open func crop(_ mode: ImageCropMode) -> CloudinaryURL {
        params.append("c_\(mode.rawValue)")
        return self
    }

    open func aspectRatio(ratio ar: String) -> CloudinaryURL {
        params.append("ar_\(ar)")
        return self
    }

    open func aspectRatio(percent ar: Float) -> CloudinaryURL {
        params.append("ar_\(ar)")
        return self
    }

    open func gravity(g: ImageGravityMode) -> CloudinaryURL {
        params.append("g_\(g.rawValue)")
        return self
    }

    open func zoom(percent p: Float) -> CloudinaryURL {
        params.append("z_\(p)")
        return self
    }

    open func xPos(pixels x: Int) -> CloudinaryURL {
        params.append("x_\(x)")
        return self
    }

    open func xPos(percent x: Float) -> CloudinaryURL {
        params.append("x_\(x)")
        return self
    }

    open func yPos(pixels y: Int) -> CloudinaryURL {
        params.append("y_\(y)")
        return self
    }

    open func yPos(percent y: Float) -> CloudinaryURL {
        params.append("y_\(y)")
        return self
    }

    open func quality(percent p: Float) -> CloudinaryURL {
        params.append("q_\(p)")
        return self
    }

    open func radius(pixels px: Int) -> CloudinaryURL {
        params.append("r_\(px)")
        return self
    }

    open func maxRadius() -> CloudinaryURL {
        params.append("r_max")
        return self
    }

    open func rotate(angle a: ImageRotation) -> CloudinaryURL {
        params.append("a_\(a.rawValue)")
        return self
    }

    open func addEffect(effect e: ImageEffect) -> CloudinaryURL {
        params.append("e_\(e.rawValue)")
        return self
    }

    open func opacity(opacity op: Int) -> CloudinaryURL {
        params.append("o_\(op)")
        return self
    }

    open func border(border b: String) -> CloudinaryURL {
        params.append("bo_\(b)")
        return self
    }

    open func backgroundColor(identifier color: String) -> CloudinaryURL {
        params.append("b_\(color)")
        return self
    }

    open func backgroundColor(rgb color: String) -> CloudinaryURL {
        params.append("b_rgb:\(color)")
        return self
    }

    open func overlay(id: String) -> CloudinaryURL {
        params.append("l_\(id)")
        return self
    }

    open func overlayText(text: String) -> CloudinaryURL {
        params.append("l_text:\(text)")
        return self
    }

    open func underlay(id: String) -> CloudinaryURL {
        params.append("u_\(id)")
        return self
    }

    open func defaultImage(id: String) -> CloudinaryURL {
        params.append("d_\(id)")
        return self
    }

    open func delay(delay: Int) ->  CloudinaryURL {
        params.append("dl_\(delay)")
        return self
    }

    open func color(identifier color: String) -> CloudinaryURL {
        params.append("co_\(color)")
        return self
    }

    open func color(rgb color: String) -> CloudinaryURL {
        params.append("co_rgb:\(color)")
        return self
    }

    open func devicePixelRatio(ratio r: Float) -> CloudinaryURL {
        params.append("dpr_\(r)")
        return self
    }

    open func page(page pg: Int) -> CloudinaryURL {
        params.append("pg_\(pg)")
        return self
    }

    open func dpi(dpi: Int) -> CloudinaryURL {
        params.append("dn_\(dpi)")
        return self
    }

    open func addFlags(flags: ImageFlag...) -> CloudinaryURL {
        let arg = flags.map { $0.rawValue }.joined(separator: ".")
        params.append("fl_\(arg)")
        return self
    }

    open func namedTransformation(name: String) -> CloudinaryURL {
        params.append("t_\(name)")
        return self
    }
}
