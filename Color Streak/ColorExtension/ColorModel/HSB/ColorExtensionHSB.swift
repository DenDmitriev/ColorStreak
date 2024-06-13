//
//  ColorExtensionHSB.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 27.05.2024.
//

import SwiftUI

extension HSB {
    /// Creates HSB from `Color`.
    public init(color: Color) {
        let cgColor = UIColor(color).cgColor
        let hsb = HSBCalculator.rgb2hsb(rgb: .init(r: cgColor.red, g: cgColor.green, b: cgColor.blue))
        
        self.hue = hsb.h / 360
        self.saturation = hsb.s
        self.brightness = hsb.b
        self.alpha = cgColor.alpha
    }
    
    /// Creates HSB from `CGColor`.
    public init(cgColor: CGColor) {
        let hsb = HSBCalculator.rgb2hsb(rgb: .init(r: cgColor.red, g: cgColor.green, b: cgColor.blue))
        
        self.hue = hsb.h / 360
        self.saturation = hsb.s
        self.brightness = hsb.b
        self.alpha = cgColor.alpha
    }
}

extension HSB: CustomStringConvertible {
    public var description: String {
        "HSB(\(Int(hue360)), \(Int(saturation * 100)), \(Int(brightness * 100)))"
    }
}

extension Color {
    public var hsb: HSB {
        HSB(color: self)
    }
}
