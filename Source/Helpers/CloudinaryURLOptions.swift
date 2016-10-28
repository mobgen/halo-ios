//
//  ImageURLOptions.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

public enum ImageCropMode: String {
    case Scale = "scale"
    case Fit = "fit"
    case Limit = "limit"
    case ScaleFit = "mfit"
    case Fill = "fill"
    case LargeFill = "lfill"
    case Pad = "pad"
    case LargePad = "lpad"
    case ScalePad = "mpad"
    case Crop = "crop"
    case Thumb = "thumb"
    case AOICrop = "imagga_crop" // Crop using Area Of Interest
    case AOIScale = "imagga_scale" // Scale using Area Of Interest
}

public enum ImageGravityMode: String {
    case NorthWest = "north_west"
    case North = "north"
    case NorthEast = "north_east"
    case West = "west"
    case Center = "center"
    case East = "east"
    case South = "south"
    case SouthWest = "south_west"
    case SouthEast = "south_east"
    case XYCenter = "xy_center"
    case Face = "face"
    case FaceCenter = "face:center"
    case Faces = "faces"
    case FacesCenter = "faces:center"
    case LargestFace = "adv_face"
    case AllFaces = "adv_faces"
    case LargestEyes = "adv_eyes"
    case Custom = "custom"
    case CustomFace = "custom:face"
    case CustomFaces = "custom:faces"
    case CustomLargestFace = "custom:adv_face"
    case CustomAllFaces = "custom:adv_faces"
}

public enum ImageRotation {
    case autoRight
    case autoLeft
    case ignore
    case verticalFlip
    case horizontalFlip
    case custom(Float)

    public var rawValue: String {
        switch self {
        case .autoRight:
            return "auto_right"
        case .autoLeft:
            return "auto_left"
        case .ignore:
            return "ignore"
        case .verticalFlip:
            return "vflip"
        case .horizontalFlip:
            return "hflip"
        case .custom(let angle):
            return String(angle)
        }
    }
}

public enum ImageEffect {

    case hue(Int?)
    case red(Int?)
    case green(Int?)
    case blue(Int?)
    case negate
    case brightness(Int?)
    case sepia(Int?)
    case grayscale
    case blackAndWhite
    case saturation(Int?)
    case colorize(Int?)
    case contrast(Int?)
    case autoContrast
    case vibrance(Int?)
    case autoColor
    case improve
    case autoBrightness
    case fillLight(Int?)
    case viesusCorrect
    case gamma(Int?)
    case screen
    case multiply
    case overlay
    case makeTransparent
    case trim(Int?)
    case shadow(Int?)
    case distort((Int, Int),(Int, Int),(Int, Int),(Int, Int))
    case shear(Float, Float)
    case displace
    case oilPaint(Int?)
    case redEye
    case advancedRedEye
    case vignette(Int?)
    case gradientFade(Int?)
    case pixelate(Int?)
    case pixelateFaces(Int?)
    case blur(Int?)
    case blurFaces(Int?)
    case sharpen(Int?)
    case unsharpMask(Int?)

    public var rawValue: String {
        switch self {
        case .hue(let value):
            if let v = value , (-100...100) ~= v {
                return "hue:\(v)"
            }
            return "hue"
        case .red(let value):
            if let v = value , (-100...100) ~= v {
                return "red:\(v)"
            }
            return "red"
        case .green(let value):
            if let v = value , (-100...100) ~= v {
                return "green:\(v)"
            }
            return "green"
        case .blue(let value):
            if let v = value , (-100...100) ~= v {
                return "blue:\(v)"
            }
            return "blue"
        case .negate:
            return "negate"
        case .brightness(let value):
            if let v = value , (-99...100) ~= v {
                return "brightness:\(v)"
            }
            return "brightness"
        case .sepia(let value):
            if let v = value , (1...100) ~= v {
                return "sepia:\(v)"
            }
            return "sepia"
        case .grayscale:
            return "grayscale"
        case .blackAndWhite:
            return "blackwhite"
        case .saturation(let value):
            if let v = value , (-100...100) ~= v {
                return "saturation:\(v)"
            }
            return "saturation"
        case .colorize(let value):
            if let v = value , (0...100) ~= v {
                return "colorize:\(v)"
            }
            return "colorize"
        case .contrast(let value):
            if let v = value , (-100...100) ~= v {
                return "contrast:\(v)"
            }
            return "contrast"
        case .autoContrast:
            return "auto_contrast"
        case .vibrance(let value):
            if let v = value , (-100...100) ~= v {
                return "vibrance:\(v)"
            }
            return "vibrance"
        case .autoColor:
            return "auto_color"
        case .improve:
            return "improve"
        case .autoBrightness:
            return "auto_brightness"
        case .fillLight(let value):
            if let v = value , (-100...100) ~= v {
                return "fill_light:\(v)"
            }
            return "fill_light"
        case .viesusCorrect:
            return "viesus_correct"
        case .gamma(let value):
            if let v = value , (-50...150) ~= v {
                return "gamma:\(v)"
            }
            return "gamma"
        case .screen:
            return "screen"
        case .multiply:
            return "multiply"
        case .overlay:
            return "overlay"
        case .makeTransparent:
            return "make_transparent"
        case .trim(let value):
            if let v = value , (0...100) ~= v {
                return "trim:\(v)"
            }
            return "trim"
        case .shadow(let value):
            if let v = value , (0...100) ~= v {
                return "shadow:\(v)"
            }
            return "shadow"
        case .distort(let p0, let p1, let p2, let p3):
            return "distort:\(p0.0):\(p0.1):\(p1.0):\(p1.1):\(p2.0):\(p2.1):\(p3.0):\(p3.1)"
        case .shear(let xAxis, let yAxis):
            return "shear:\(xAxis):\(yAxis)"
        case .displace:
            return "displace"
        case .oilPaint(let value):
            if let v = value , (0...100) ~= v {
                return "oil_paint:\(v)"
            }
            return "oil_paint"
        case .redEye:
            return "redeye"
        case .advancedRedEye:
            return "adv_redeye"
        case .vignette(let value):
            if let v = value , (0...100) ~= v {
                return "vignette:\(v)"
            }
            return "vignette"
        case .gradientFade(let value):
            if let v = value , (0...100) ~= v {
                return "gradient_fade:\(v)"
            }
            return "gradient_fade"
        case .pixelate(let value):
            if let v = value , (1...200) ~= v {
                return "pixelate:\(v)"
            }
            return "pixelate"
        case .pixelateFaces(let value):
            if let v = value , (1...200) ~= v {
                return "pixelate_faces:\(v)"
            }
            return "pixelate_faces"
        case .blur(let value):
            if let v = value , (1...2000) ~= v {
                return "blur:\(v)"
            }
            return "blur"
        case .blurFaces(let value):
            if let v = value , (1...2000) ~= v {
                return "blur_faces:\(v)"
            }
            return "blur_faces"
        case .sharpen(let value):
            if let v = value , (1...2000) ~= v {
                return "sharpen:\(v)"
            }
            return "sharpen"
        case .unsharpMask(let value):
            if let v = value , (1...2000) ~= v {
                return "unsharp_mask:\(v)"
            }
            return "unsharp_mask"
        }
    }
}

public enum ImageFlag: String {
    case KeepIptc = "keep_iptc"
    case Attachment = "attachment"
    case Relative = "relative"
    case RegionRelative = "region_relative"
    case Progressive = "progressive"
    case Png8 = "png8"
    case ForceStrip = "force_strip"
    case Cutter = "cutter"
    case Clip = "clip"
    case AWebP = "awebp"
    case LayerApply = "layer_apply"
    case IgnoreAspectRatio = "ignore_aspect_ratio"
    case Tiled = "tiled"
    case Lossy = "lossy"
    case StripProfile = "strip_profile"
    case Rasterize = "rasterize"
    case TextNoTrim = "text_no_trim"
}
