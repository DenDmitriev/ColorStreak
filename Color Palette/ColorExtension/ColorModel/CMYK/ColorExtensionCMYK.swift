//
//  ColorExtensionCMYK.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 27.05.2024.
//

import SwiftUI

extension CMYK {
    public init(color: Color) {
        let cgColor = UIColor(color).cgColor
        let cmyk = CMYKCalculator.rgbToCmyk(rgb: .init(r: cgColor.red, g: cgColor.green, b: cgColor.blue))
        
        self.cyan = cmyk.c
        self.magenta = cmyk.m
        self.yellow = cmyk.y
        self.black = cmyk.k
    }
    
    public init(cgColor: CGColor) {
        let cmyk = CMYKCalculator.rgbToCmyk(rgb: .init(r: cgColor.red, g: cgColor.green, b: cgColor.blue))
        
        self.cyan = cmyk.c
        self.magenta = cmyk.m
        self.yellow = cmyk.y
        self.black = cmyk.k
    }
}

extension Color {
    public var cmyk: CMYK {
        CMYK(color: self)
    }
    
    init(cmyk: CMYK) {
        let rgb = CMYKCalculator.cmykToRgb(cmyk: .init(c: cmyk.cyan, m: cmyk.magenta, y: cmyk.yellow, k: cmyk.black))
        let cgColor = CGColor(srgbRed: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0)
        self.init(cgColor: cgColor)
    }
}
