//
//  ColorExtensionRotated.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import SwiftUI

extension Color {
    public func rotated(angle: Angle) -> Self {
        let hsb = self.hsb
        
        let rotatedHue = Angle(degrees: (hsb.hue360 + angle.degrees).normalizedDegrees())
        let partDegrees = rotatedHue.degrees / 360
        
        let cgColor = UIColor(self).cgColor
        let alpha = cgColor.alpha
        
        return Color(
            hue: partDegrees,
            saturation: hsb.saturation,
            brightness: hsb.brightness,
            opacity: alpha
        )
    }
}
