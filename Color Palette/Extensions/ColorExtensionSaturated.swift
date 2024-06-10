//
//  ColorExtensionSaturated.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import SwiftUI

extension Color {
    public func saturated(delta: Double) -> Self {
        let hsb = self.hsb
        
        let saturated = max(min(hsb.saturation + delta, 1), 0)
        let alpha = UIColor(self).cgColor.alpha
        
        return Color(
            hue: hsb.hue,
            saturation: saturated,
            brightness: hsb.brightness,
            opacity: alpha
        )
    }
}
