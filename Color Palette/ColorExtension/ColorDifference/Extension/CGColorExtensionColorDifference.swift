//
//  CGColorExtensionColorDifference.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
//

import Foundation
import CoreGraphics.CGColor

extension CGColor {
    /// Calculates the difference between two colors.
    ///
    /// In color science, color difference or color distance is the separation between two colors.
    /// This metric allows quantified examination of a notion that formerly could only be described with adjectives.
    /// [Color difference](https://en.wikipedia.org/wiki/Color_difference)
    ///
    /// - Parameters:
    ///   - sample: Sample color.
    ///   - formula: The algorithm to use to make the comparison.
    /// - Returns: The color difference, or ΔE, between a sample color and a source (reference) color.
    public func difference(sample: CGColor, formula: ColorDistanceFormula = .CIE94) -> Double {
        ColorDifference.difference(reference: self, sample: sample, formula: formula)
    }
}
