//
//  HSB.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 19.05.2024.
//

import Foundation

public struct HSB {
    /// A value in the range 0 to 1 that maps to an angle from 0° to 360° to represent a shade on the color wheel.
    public let hue: CGFloat
    /// A value in the range 0 to 1 that indicates how strongly the hue affects the color. A value of 0 removes the effect of the hue, resulting in gray. As the value increases, the hue becomes more prominent.
    public let saturation: CGFloat
    /// A value in the range 0 to 1 that indicates how bright a color is. A value of 0 results in black, regardless of the other components. The color lightens as you increase this component.
    public let brightness: CGFloat
    /// An optional degree of opacity, given in the range 0 to 1. A value of 0 means 100% transparency, while a value of 1 means 100% opacity. The default is 1.
    public let alpha: CGFloat
    
    /// Hue in degrees from 0° to 360°
    public var hue360: CGFloat {
        let degrees = (hue * 360).roundedDecimal(4)
        return max(min(degrees, 360), 0)
    }
}
