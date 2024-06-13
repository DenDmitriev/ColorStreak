//
//  ColorExtensionBrightened.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import SwiftUI

extension Color {
    public func brightened(delta: Double) -> Self {
        let hsb = self.hsb
        
        let brightened = max(min(hsb.brightness + delta, 1), 0)
        let alpha = UIColor(self).cgColor.alpha
        
        return Color(
            hue: hsb.hue,
            saturation: hsb.saturation,
            brightness: brightened,
            opacity: alpha
        )
    }
}

extension Color {
    public func moved(deltaHue: Angle, deltaSaturation: Double, deltaBrightness: Double) -> Self {
        let hsb = self.hsb
        
        var rotatedHue = Angle(degrees: hsb.hue * 360) + deltaHue
        let partDegrees = rotatedHue.degrees / 360
        if !(0...1 ~= partDegrees) {
            rotatedHue = Angle(degrees: partDegrees.normalizedDegrees() * 360)
        }
        let saturated = max(min(hsb.saturation + deltaSaturation, 1), 0)
        let brightened = max(min(hsb.brightness + deltaBrightness, 1), 0)
        
        let alpha = UIColor(self).cgColor.alpha
        
        return Color(
            hue: rotatedHue.degrees / 360,
            saturation: saturated,
            brightness: brightened,
            opacity: alpha
        )
    }
}
