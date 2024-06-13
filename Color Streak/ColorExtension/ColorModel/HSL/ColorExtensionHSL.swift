//
//  ColorExtensionHSL.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 27.05.2024.
//

import SwiftUI

extension HSL {
    /// Creates HSL from `Color`.
    public init(color: Color) {
        var hue: CGFloat = .zero
        var saturation: CGFloat = .zero
        var brightness: CGFloat = .zero
        var alpha: CGFloat = .zero
        
        let uiColor = UIColor(color)
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        let lightness = ((2 - saturation) * brightness) / 2
        
        self.hue = hue
        self.saturation = saturation
        self.lightness = lightness
        self.alpha = alpha
    }
    
    /// Creates HSL from `CGColor`.
    public init(cgColor: CGColor) {
        var hue: CGFloat = .zero
        var saturation: CGFloat = .zero
        var brightness: CGFloat = .zero
        var alpha: CGFloat = .zero
        
        let uiColor = UIColor(cgColor: cgColor)
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        let lightness = ((2 - saturation) * brightness) / 2
        
        self.hue = hue
        self.saturation = saturation
        self.lightness = lightness
        self.alpha = alpha
    }
}

extension Color {
    public var hsl: HSL {
        HSL(color: self)
    }
}
