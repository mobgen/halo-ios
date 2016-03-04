//
//  ImageURLOptions.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 04/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

public enum CropMode: String {
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

public enum GravityMode: String {
    case NorthWest = "north_west"
    case North = "north"
    case NorthEast = "north_east"
    case West = "west"
    case Center = "center"
    case East = "east"
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

public enum Rotation {
    case AutoRight
    case AutoLeft
    case Ignore
    case VerticalFlip
    case HorizontalFlip
    case Custom(Int)
    
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

public enum Effect {
    
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
    case Distort((Int,Int),(Int,Int),(Int,Int),(Int,Int))
    case Shear(Float,Float)
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
                return "hue:\(value)"
            }
            return "hue"
        case .Red(let value):
            if let v = value where (-100...100) ~= v {
                return "red:\(value)"
            }
            return "red"
        case .Green(let value):
            if let v = value where (-100...100) ~= v {
                return "green:\(value)"
            }
            return "green"
        case .Blue(let value):
            if let v = value where (-100...100) ~= v {
                return "blue:\(value)"
            }
            return "blue"
        case .Negate:
            return "negate"
        case .Brightness(let value):
            if let v = value where (-99...100) ~= v {
                return "brightness:\(value)"
            }
            return "brightness"
        case .Sepia(let value):
            return ((1...100) ~= value) ? "sepia:\(value)" : "sepia"
        case .Grayscale:
            return "grayscale"
        case .BlackAndWhite:
            return "blackwhite"
        case .Saturation(let value):
            return ((-100...100) ~= value) ? "saturation:\(value)" : "saturation"
        case .Colorize(let value):
            return ((0...100) ~= value) ? "colorize:\(value)" : "colorize"
        case .Contrast(let value):
            return ((-100...100) ~= value) ? "contrast:\(value)" : "contrast"
        case .AutoContrast:
            return "auto_contrast"
        case .Vibrance(let value):
            return ((-100...100) ~= value) ? "vibrance:\(value)" : "vibrance"
        case .AutoColor:
            return "auto_color"
        case .Improve:
            return "improve"
        case .AutoBrightness:
            return "auto_brightness"
        case .FillLight(let value):
            return ((-100...100) ~= value) ? "fill_light:\(value)" : "fill_light"
        case .ViesusCorrect:
            return "viesus_correct"
        case .Gamma(let value):
            return ((-50...150) ~= value) ? "gamma:\(value)" : "gamma"
        case .Screen:
            return "screen"
        case .Multiply:
            return "multiply"
        case .Overlay:
            return "overlay"
        case .MakeTransparent:
            return "make_transparent"
        case .Trim(let value):
            return ((0...100) ~= value) ? "trim:\(value)" : "trim"
        case .Shadow(let value):
            return ((0...100) ~= value) ? "shadow:\(value)" : "shadow"
        case .Distort(let p0, let p1, let p2, let p3):
            return "distort:\(p0.0):\(p0.1):\(p1.0):\(p1.1):\(p2.0):\(p2.1):\(p3.0):\(p3.1)"
        case .Shear(let xAxis, let yAxis):
            return "shear:\(xAxis):\(yAxis)"
        case .Displace:
            return "displace"
        case .OilPaint(let value):
            return ((0...100) ~= value) ? "oil_paint:\(value)" : "oil_paint"
        case .RedEye:
            return "redeye"
        case .AdvancedRedEye:
            return "adv_redeye"
        case .Vignette(let value):
            return ((0...100) ~= value) ? "vignette:\(value)" : "vignette"
        case .GradientFade(let value):
            return ((0...100) ~= value) ? "gradient_fade:\(value)" : "gradient_fade"
        case .Pixelate(let value):
            return ((1...200) ~= value) ? "pixelate:\(value)" : "pixelate"
        case .PixelateFaces(let value):
            return ((1...200) ~= value) ? "pixelate_faces:\(value)" : "pixelate_faces"
        case .Blur(let value):
            return ((1...2000) ~= value) ? "blur:\(value)" : "blur"
        case .BlurFaces(let value):
            return ((1...2000) ~= value) ? "blur_faces:\(value)" : "blur_faces"
        }
    }
}