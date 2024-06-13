//
//  ReferenceWhite.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 18.05.2024.
//

import Foundation

public enum ReferenceWhite: String {
    case D65
    case D50
    case E
    case C
    
    
    /// Chromatic Adaptation Matrices
    /// Precomputed matrices for [M]
    ///
    /// [Chromatic Adaptation](http://www.brucelindbloom.com/index.html?ColorDifferenceCalc.html)
    public var chromaticAdaptationMatrices: [Double] {
        switch self {
        case .D65:
            [0.95047, 1.00000, 1.08883]
        case .D50:
            [0.96422, 1.00000, 0.82521]
        case .E:
            [1, 1, 1]
        case .C:
            [0.98074, 1.00000, 1.18232]
        }
    }
}
