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
    case AutoRight
    case AutoLeft
    case Ignore
    case VerticalFlip
    case HorizontalFlip
    case Custom(Float)

    public var rawValue: String {
        switch self {
        case .AutoRight:
            return "auto_right"
        case .AutoLeft:
            return "auto_left"
        case .Ignore:
            return "ignore"
        case .VerticalFlip:
            return "vflip"
        case .HorizontalFlip:
            return "hflip"
        case .Custom(let angle):
            return String(angle)
        }
    }
}

public enum ImageEffect {

    case Hue(Int?)
    case Red(Int?)
    case Green(Int?)
    case Blue(Int?)
    case Negate
    case Brightness(Int?)
    case Sepia(Int?)
    case Grayscale
    case BlackAndWhite
    case Saturation(Int?)
    case Colorize(Int?)
    case Contrast(Int?)
    case AutoContrast
    case Vibrance(Int?)
    case AutoColor
    case Improve
    case AutoBrightness
    case FillLight(Int?)
    case ViesusCorrect
    case Gamma(Int?)
    case Screen
    case Multiply
    case Overlay
    case MakeTransparent
    case Trim(Int?)
    case Shadow(Int?)
    case Distort((Int, Int),(Int, Int),(Int, Int),(Int, Int))
    case Shear(Float, Float)
    case Displace
    case OilPaint(Int?)
    case RedEye
    case AdvancedRedEye
    case Vignette(Int?)
    case GradientFade(Int?)
    case Pixelate(Int?)
    case PixelateFaces(Int?)
    case Blur(Int?)
    case BlurFaces(Int?)
    case Sharpen(Int?)
    case UnsharpMask(Int?)

    public var rawValue: String {
        switch self {
        case .Hue(let value):
            if let v = value where (-100...100) ~= v {
                return "hue:\(v)"
            }
            return "hue"
        case .Red(let value):
            if let v = value where (-100...100) ~= v {
                return "red:\(v)"
            }
            return "red"
        case .Green(let value):
            if let v = value where (-100...100) ~= v {
                return "green:\(v)"
            }
            return "green"
        case .Blue(let value):
            if let v = value where (-100...100) ~= v {
                return "blue:\(v)"
            }
            return "blue"
        case .Negate:
            return "negate"
        case .Brightness(let value):
            if let v = value where (-99...100) ~= v {
                return "brightness:\(v)"
            }
            return "brightness"
        case .Sepia(let value):
            if let v = value where (1...100) ~= v {
                return "sepia:\(v)"
            }
            return "sepia"
        case .Grayscale:
            return "grayscale"
        case .BlackAndWhite:
            return "blackwhite"
        case .Saturation(let value):
            if let v = value where (-100...100) ~= v {
                return "saturation:\(v)"
            }
            return "saturation"
        case .Colorize(let value):
            if let v = value where (0...100) ~= v {
                return "colorize:\(v)"
            }
            return "colorize"
        case .Contrast(let value):
            if let v = value where (-100...100) ~= v {
                return "contrast:\(v)"
            }
            return "contrast"
        case .AutoContrast:
            return "auto_contrast"
        case .Vibrance(let value):
            if let v = value where (-100...100) ~= v {
                return "vibrance:\(v)"
            }
            return "vibrance"
        case .AutoColor:
            return "auto_color"
        case .Improve:
            return "improve"
        case .AutoBrightness:
            return "auto_brightness"
        case .FillLight(let value):
            if let v = value where (-100...100) ~= v {
                return "fill_light:\(v)"
            }
            return "fill_light"
        case .ViesusCorrect:
            return "viesus_correct"
        case .Gamma(let value):
            if let v = value where (-50...150) ~= v {
                return "gamma:\(v)"
            }
            return "gamma"
        case .Screen:
            return "screen"
        case .Multiply:
            return "multiply"
        case .Overlay:
            return "overlay"
        case .MakeTransparent:
            return "make_transparent"
        case .Trim(let value):
            if let v = value where (0...100) ~= v {
                return "trim:\(v)"
            }
            return "trim"
        case .Shadow(let value):
            if let v = value where (0...100) ~= v {
                return "shadow:\(v)"
            }
            return "shadow"
        case .Distort(let p0, let p1, let p2, let p3):
            return "distort:\(p0.0):\(p0.1):\(p1.0):\(p1.1):\(p2.0):\(p2.1):\(p3.0):\(p3.1)"
        case .Shear(let xAxis, let yAxis):
            return "shear:\(xAxis):\(yAxis)"
        case .Displace:
            return "displace"
        case .OilPaint(let value):
            if let v = value where (0...100) ~= v {
                return "oil_paint:\(v)"
            }
            return "oil_paint"
        case .RedEye:
            return "redeye"
        case .AdvancedRedEye:
            return "adv_redeye"
        case .Vignette(let value):
            if let v = value where (0...100) ~= v {
                return "vignette:\(v)"
            }
            return "vignette"
        case .GradientFade(let value):
            if let v = value where (0...100) ~= v {
                return "gradient_fade:\(v)"
            }
            return "gradient_fade"
        case .Pixelate(let value):
            if let v = value where (1...200) ~= v {
                return "pixelate:\(v)"
            }
            return "pixelate"
        case .PixelateFaces(let value):
            if let v = value where (1...200) ~= v {
                return "pixelate_faces:\(v)"
            }
            return "pixelate_faces"
        case .Blur(let value):
            if let v = value where (1...2000) ~= v {
                return "blur:\(v)"
            }
            return "blur"
        case .BlurFaces(let value):
            if let v = value where (1...2000) ~= v {
                return "blur_faces:\(v)"
            }
            return "blur_faces"
        case .Sharpen(let value):
            if let v = value where (1...2000) ~= v {
                return "sharpen:\(v)"
            }
            return "sharpen"
        case .UnsharpMask(let value):
            if let v = value where (1...2000) ~= v {
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
