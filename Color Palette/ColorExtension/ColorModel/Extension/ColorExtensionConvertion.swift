//
//  ColorExtensionConvertion.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 19.05.2024.
//

import SwiftUI

extension Color {
    public func converted(cgColorSpace: CGColorSpace, intent: CGColorRenderingIntent = .defaultIntent) -> Self {
        let cgColor = UIColor(self).cgColor
        if cgColor.colorSpace != cgColorSpace {
            let convertedCgColor = cgColor.converted(to: cgColorSpace, intent: intent, options: nil) ?? CGColor(srgbRed: cgColor.red, green: cgColor.green, blue: cgColor.blue, alpha: cgColor.alpha)
            
            return Self(cgColor: convertedCgColor)
        } else {
            return self
        }
    }
    
    public func converted(colorSpace: ColorSpace, intent: CGColorRenderingIntent = .defaultIntent) -> Self {
        let cgColor = UIColor(self).cgColor
        let cgColorSpace = colorSpace.cgColorSpace ?? CGColorSpaceCreateDeviceRGB()
        if cgColor.colorSpace != cgColorSpace {
            let convertedCgColor = cgColor.converted(to: cgColorSpace, intent: intent, options: nil) ?? CGColor(srgbRed: cgColor.red, green: cgColor.green, blue: cgColor.blue, alpha: cgColor.alpha)
            
            return Self(cgColor: convertedCgColor)
        } else {
            return self
        }
    }
    
    public var colorSpace: ColorSpace {
        let cgColor = UIColor(self).cgColor
        let cgColorSpace = cgColor.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        let colorSpace = ColorSpace(cgColorSpace: cgColorSpace)
        
        return colorSpace
    }
    
    public var cgColorSpace: CGColorSpace {
        let cgColor = UIColor(self).cgColor
        let cgColorSpace = cgColor.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        
        return cgColorSpace
    }
    
    public var rgbColorSpace: Color.RGBColorSpace {
        let cgColor = UIColor(self).cgColor
        let cgColorSpace = cgColor.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        
        switch cgColorSpace {
        case CGColorSpace(name: CGColorSpace.displayP3):
            return .displayP3
        case CGColorSpace(name: CGColorSpace.sRGB):
            return .sRGB
        case CGColorSpace(name: CGColorSpace.linearSRGB):
            return .sRGBLinear
        default:
            return .sRGB
        }
    }
}

