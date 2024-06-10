//
//  LabCalculator.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
//

import Foundation

struct LabCalculator {
    static func convert(RGB: RGB, workingSpace: RGBWorkingSpace = .sRGB) -> Lab {
        let XYZ = XYZCalculator.convert(rgb: RGB, workingSpace: workingSpace)
        let Lab: Lab = LabCalculator.convert(XYZ: XYZ, workingSpace: workingSpace)
        return Lab
    }
    
    static func convert(Lab: Lab, workingSpace: RGBWorkingSpace = .sRGB) -> RGB {
        let XYZ = XYZCalculator.convert(Lab: Lab, workingSpace: workingSpace)
        let RGB: RGB = LabCalculator.convert(XYZ: XYZ, workingSpace: workingSpace)
        return RGB
    }
    
    /// http://www.brucelindbloom.com/index.html?Eqn_XYZ_to_Lab.html
    static func convert(XYZ: XYZ, workingSpace: RGBWorkingSpace) -> Lab {
        func transform(value: CGFloat) -> CGFloat {
            if value > pow(6/29, 3) {
                return pow(value, 1/3)
            } else {
                return (pow(29/3, 3) * value + 16) / 116
            }
        }
        let chromaticAdaptationMatrices = workingSpace.referenceWhite.chromaticAdaptationMatrices
        let X = transform(value: XYZ.X / ( chromaticAdaptationMatrices[0] * 100))
        let Y = transform(value: XYZ.Y / ( chromaticAdaptationMatrices[1] * 100))
        let Z = transform(value: XYZ.Z / ( chromaticAdaptationMatrices[2] * 100))
        
        let L = (116.0 * Y) - 16.0
        let a = 500.0 * (X - Y)
        let b = 200.0 * (Y - Z)
        
        return Lab(L: L, a: a, b: b)
    }
    
    static func convert(XYZ: XYZ, workingSpace: RGBWorkingSpace = .sRGB) -> RGB {
        func transform(value: CGFloat) -> CGFloat {
            if value <= 0.0031308 {
                return 12.92 * value
            } else {
                return 1.055 * pow(value , (1 / 2.4)) - 0.055
            }
        }
        
        let matrix = workingSpace.XYZtoRGB
        var red = XYZ.X * matrix[0][0] + XYZ.Y * matrix[0][1] + XYZ.Z * matrix[0][2]
        var green = XYZ.X * matrix[1][0] + XYZ.Y * matrix[1][1] + XYZ.Z * matrix[1][2]
        var blue = XYZ.X * matrix[2][0] + XYZ.Y * matrix[2][1] + XYZ.Z * matrix[2][2]
        
        red = transform(value: red)
        green = transform(value: green)
        blue = transform(value: blue)
        
        return RGB(red: red, green: green, blue: blue)
    }
}
