//
//  HSBCalculator.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import Foundation

struct HSBCalculator {
    struct RGB {
        /// a fraction between 0 and 1
        let r: Double
        /// a fraction between 0 and 1
        let g: Double
        /// a fraction between 0 and 1
        let b: Double
    }
    
    struct HSB {
        /// angle in degrees
        let h: Double
        /// a fraction between 0 and 1
        let s: Double
        /// a fraction between 0 and 1
        let b: Double
    }
    
    /// RGB to HSV
    /// r,g,b values are from 0 to 1
    /// h = [0,360], s = [0,1], v = [0,1]
    /// [RGB to HSV](https://www.cs.rit.edu/~ncs/color/t_convert.html#RGB%20to%20HSV%20&%20HSV%20to%20RGB)
    static func rgb2hsb(rgb: RGB) -> HSB {
        let r = rgb.r
        let g = rgb.g
        let b = rgb.b
        
        let min = min(r, g, b)
        let max = max(r, g, b)
        
        let v = max
        
        var h = 0.0
        var s = 0.0
        let delta = max - min
        if max != 0 {
            s = delta / max
        } else {
            s = 0
            h = 0
            return HSB(h: h, s: s, b: v)
        }
        if r == max {
            // between yellow & magenta
            h = ( g - b ) / delta
        } else if ( g == max ) {
            // between cyan & yellow
            h = 2 + ( b - r ) / delta
        } else {
            // between magenta & cyan
            h = 4 + ( r - g ) / delta
        }
        h = h.isNaN ? 0: h
        h *= 60
        if h < 0  {
            h += 360
        }
        return HSB(h: h, s: s, b: v)
    }
    
    /// HSV to RGB
    /// r,g,b values are from 0 to 1
    /// h = [0,360], s = [0,1], v = [0,1]
    /// [HSV to RGB](https://www.cs.rit.edu/~ncs/color/t_convert.html#RGB%20to%20HSV%20&%20HSV%20to%20RGB)
    static func hsb2rgb(hsb: HSB) -> RGB {
        var h = hsb.h
        let s = hsb.s
        let b = hsb.b
        
        if s == 0 {
            // achromatic (grey)
            return RGB(r: b, g: b, b: b)
        }
        
        let hi = Int(h / 60) % 6
        let bmin = (1 - s) * b
        let a = (b - bmin) * Double(Int(h) % 60) / 60
        let binc = bmin + a
        let bdec = b - a
        
        let red: Double
        let green: Double
        let blue: Double
        switch hi {
        case 0:
            red = b
            green = binc
            blue = bmin
        case 1:
            red = bdec
            green = b
            blue = bmin
        case 2:
            red = bmin
            green = b
            blue = binc
        case 3:
            red = bmin
            green = bdec
            blue = b
        case 4:
            red = binc
            green = bmin
            blue = b
        default: // 5
            red = b
            green = bmin
            blue = bdec
        }
        
        return RGB(r: red, g: green, b: blue)
    }
    
}
