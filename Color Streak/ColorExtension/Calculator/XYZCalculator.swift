//
//  XYZCalculator.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 18.05.2024.
//

import Foundation

struct XYZCalculator {
    
    static func convert(rgb: RGB, workingSpace: RGBWorkingSpace = .sRGB) -> XYZ {
        /// [RGB to XYZ](http://www.brucelindbloom.com/index.html?ColorDifferenceCalc.html)
        func transform(value: CGFloat) -> CGFloat {
            if value > 0.04045 {
                return pow((value + 0.055) / 1.055, 2.4)
            } else {
                return value / 12.92
            }
        }
        
        let red = transform(value: rgb.red) * 100.0
        let green = transform(value: rgb.green) * 100.0
        let blue = transform(value: rgb.blue) * 100.0
        
        let matrix = workingSpace.RGBtoXYZ
        
        let X = (red * matrix[0][0] + green * matrix[0][1] + blue * matrix[0][2])
        let Y = (red * matrix[1][0] + green * matrix[1][1] + blue * matrix[1][2])
        let Z = (red * matrix[2][0] + green * matrix[2][1] + blue * matrix[2][2])

        return XYZ(X: X, Y: Y, Z: Z)
    }
    
    /// http://www.brucelindbloom.com/index.html?ColorDifferenceCalc.html
    static func convert(Lab: Lab, workingSpace: RGBWorkingSpace = .sRGB) -> XYZ {
        func transform(value: CGFloat) -> CGFloat {
            let valuePow3 = pow(value, 3)
            if valuePow3 > 0.008856 {
                return valuePow3
            } else {
                return (value - 16 / 116) / 7.787
            }
            
        }
        
        let fY: CGFloat = ( Lab.L + 16 ) / 116
        let fX: CGFloat = Lab.a / 500 + fY
        let fZ: CGFloat = fY - Lab.b / 200
        
        let chromaticAdaptationMatrices = workingSpace.referenceWhite.chromaticAdaptationMatrices
        let X = transform(value: fX) * chromaticAdaptationMatrices[0]
        let Y = transform(value: fY) * chromaticAdaptationMatrices[1]
        let Z = transform(value: fZ) * chromaticAdaptationMatrices[2]
        
        return XYZ(X: X, Y: Y, Z: Z)
    }
    
}
