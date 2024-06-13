//
//  CMYK.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 27.05.2024.
//

import Foundation

/// The CMYK color model  is a subtractive color model.
public struct CMYK {
    /// The cyan component of the color ranges from 0 to 1.
    public var cyan: CGFloat
    /// The magenta component of the color, in the ranges from 0 to 1.
    public var magenta: CGFloat
    /// The yellow component of the color, in the ranges from 0 to 1.
    public var yellow: CGFloat
    /// The black component of the color, in the ranges from 0 to 1.
    public var black: CGFloat
    /// The black component of the color, in the ranges from 0 to 1.
    public var key: CGFloat { black }
    
    public var cyanPercent: CGFloat { cyan * 100 }
    public var magentaPercent: CGFloat { magenta * 100 }
    public var yellowPercent: CGFloat { yellow * 100 }
    public var blackPercent: CGFloat { black * 100 }
    
    public init(cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat) {
        self.cyan = cyan
        self.magenta = magenta
        self.yellow = yellow
        self.black = black
    }
}

extension CMYK: CustomStringConvertible {
    public var description: String {
        let cyanFormatted = Double(cyan).roundedDecimal(2).formatted(.percent)
        let magentaFormatted = Double(magenta).roundedDecimal(2).formatted(.percent)
        let yellowFormatted = Double(yellow).roundedDecimal(2).formatted(.percent)
        let keyFormatted = Double(black).roundedDecimal(2).formatted(.percent)
        return "CMYK(\(cyanFormatted), \(magentaFormatted), \(yellowFormatted), \(keyFormatted))"
    }
}
