//
//  DoubleExtension+Round.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
//

import Foundation

extension Double {
    public func roundedDecimal(_ decimals: Int = 2) -> Self {
        var factor = 1
        if 1...9 ~= decimals {
            for _ in 1...decimals {
                factor *= 10
            }
        }
        return (self * Self(factor)).rounded() / Self(factor)
    }
    
    /// Returns an Angle in the range `0° ..< 360°`
    public func normalizedDegrees() -> Self {
        let degrees = (self.truncatingRemainder(dividingBy: 360) + 360)
            .truncatingRemainder(dividingBy: 360)
        
        return degrees
    }
}

extension CGFloat {
    public func roundedDecimal(_ decimals: Int = 2) -> Self {
        var factor = 1
        if 1...9 ~= decimals {
            for _ in 1...decimals {
                factor *= 10
            }
        }
        return (self * Self(factor)).rounded() / Self(factor)
    }
}
