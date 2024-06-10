//
//  CMYKCalculator.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import Foundation

struct CMYKCalculator {
    struct CMYK {
        /// 0...1
        let c: Double
        /// 0...1
        let m: Double
        /// 0...1
        let y: Double
        /// 0...1
        let k: Double
    }
    
    struct RGB {
        /// 0...1
        let r: Double
        /// 0...1
        let g: Double
        /// 0...1
        let b: Double
    }
    
    
    static func cmykToRgb(cmyk: CMYK) -> RGB {
        let w = 1 - cmyk.k
        var r = (1 - cmyk.c) * w
        var g = (1 - cmyk.m) * w
        var b = (1 - cmyk.y) * w
        
        if r > 1 { r = 1 }
        if g > 1 { g = 1 }
        if b > 1 { b = 1 }
        
        if r < 0 { r = 0 }
        if g < 0 { g = 0 }
        if b < 0 { b = 0 }

        return RGB(r: r, g: g, b: b)
    }
    
    static func rgbToCmyk(rgb: RGB) -> CMYK {
        var c = 1 - rgb.r
        var m = 1 - rgb.g
        var y = 1 - rgb.b
        let k = min(c, m, y)
        
        c = c - k
        m = m - k
        y = y - k
        
        c /= 1 - k
        m /= 1 - k
        y /= 1 - k
        
        if c < 0 { c = 0 }
        if m < 0 { m = 0 }
        if y < 0 { y = 0 }
        
        if c > 1 { c = 1 }
        if m > 1 { m = 1 }
        if y > 1 { y = 1 }
        
        if c.isNaN { c = 1 }
        if m.isNaN { m = 1 }
        if y.isNaN { y = 1 }
        
        return CMYK(c: c, m: m, y: y, k: k)
    }
}
