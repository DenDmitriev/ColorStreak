//
//  CGColorExtensionHSB.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 19.05.2024.
//

import CoreGraphics.CGColor


// HSB Converter
extension CGColor {
    
    var hsb: HSB {
        HSB(cgColor: self)
    }
}
