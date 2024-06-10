//
//  CGColorLab.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 18.05.2024.
//

import CoreGraphics.CGColor

/// Lab Converter
extension CGColor {
    /// The CIELAB color space, also referred to as L*a*b*, is a color space defined by CIE.
    public var lab: Lab {
        return LabCalculator.convert(RGB: self.rgb)
    }
}
