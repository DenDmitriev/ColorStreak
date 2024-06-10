//
//  ContrastWCAGCalculator.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 08.06.2024.
//

import CoreGraphics
import DominantColors

struct ContrastWCAGCalculator {
    /// WCAG definition of contrast ratio
    /// Contrast ratios can range from 1 to 21 (commonly written 1:1 to 21:1).
    ///  For the purpose of Success Criteria 1.4.3 and 1.4.6,
    ///  contrast is measured with respect to the specified background over which the text is rendered in normal usage.
    ///  If no background color is specified, then white is assumed.
    ///
    ///  (L1 + 0.05) / (L2 + 0.05), where
    ///  L1 is the relative luminance of the lighter of the colors, and
    ///  L2 is the relative luminance of the darker of the colors.
    static func contrastRatio(_ color1: CGColor, _ color2: CGColor, invertible: Bool = true) -> Double {
        
        let rgb1 = color1.rgb
        let rgb2 = color2.rgb
        
        let L1 = relativeLuminance(red: rgb1.red, green: rgb1.green, blue: rgb1.blue)
        let L2 = relativeLuminance(red: rgb2.red, green: rgb2.green, blue: rgb2.blue)
        
        var aspectRatio = (L1 + 0.05) / (L2 + 0.05)
        if invertible, L1 < L2 {
            aspectRatio = 1 / aspectRatio
        }
        
        let roundedAspectRatio = (aspectRatio * 100).rounded() / 100
        
        return roundedAspectRatio
    }
    
    /// Relative luminance
    /// The relative brightness of any point in a colorspace, normalized to 0 for darkest black and 1 for lightest white
    /// Input 0...1
    static private func relativeLuminance(red: Double, green: Double, blue: Double) -> Double {
        func value(_ value: Double) -> Double {
            if value <= 0.03928 {
                return value / 12.92
            } else {
                return pow((value + 0.055) / 1.055, 2.4)
            }
        }
        let relativeLuminance = 0.2126 * value(red) + 0.7152 * value(green) + 0.0722 * value(blue)
        return relativeLuminance
    }
}
