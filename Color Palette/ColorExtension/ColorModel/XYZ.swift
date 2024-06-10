//
//  XYZ.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 18.05.2024.
//

import Foundation

/// CIE XYZ color space
/// The CIE XYZ model is a master model of almost all other color models used in technical fields.
public struct XYZ {
    /// X values lie along the axis, the orthogonal Y axis (brightness) and the Z axis.
    public let X: CGFloat
    /// Channel Y represents the brightness of the color
    public let Y: CGFloat
    /// The Z channel is approximately related to the amount of blue
    /// The Z value in the XYZ color space is not identical to the B value in the RGB color space.
    public let Z: CGFloat
}
