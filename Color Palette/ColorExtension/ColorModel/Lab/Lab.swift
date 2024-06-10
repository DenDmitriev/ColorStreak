//
//  Lab.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
//

import Foundation

public struct Lab {
    /// The L* value of the CIELAB color space.
    /// L* represents the lightness of the color from 0 (black) to 100 (white).
    public var L: Double
    
    /// The a* value of the CIELAB color space.
    /// a* represents colors from green -100 to red 100 .
    public var a: Double
    
    /// The b* value of the CIELAB color space.
    /// b* represents colors from blue -100 to yellow 100.
    public var b: Double
    
    public var rounded: Self {
        let LRounded = self.L.rounded()
        let aRounded = self.a.rounded()
        let bRounded = self.b.rounded()
        return Lab(L: LRounded, a: aRounded, b: bRounded)
    }
}

extension Lab: Equatable {
    
}

extension Lab: CustomStringConvertible {
    public var description: String {
        let labRounded = self.rounded
        let LFormatted = labRounded.L.formatted(.number)
        let aFormatted = labRounded.a.formatted(.number)
        let bFormatted = labRounded.b.formatted(.number)
        
        return "Lab(\(LFormatted), \(aFormatted), \(bFormatted))"
    }
}
