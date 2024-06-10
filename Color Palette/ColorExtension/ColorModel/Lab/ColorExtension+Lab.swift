//
//  ColorExtension+Lab.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
//

import SwiftUI

extension Color {
    var lab: Lab {
        let cgColor = UIColor(self).cgColor
        
        return cgColor.lab
    }
    
    init(lab: Lab, workingSpace: RGBWorkingSpace = .sRGB) {
        let rgb: RGB = LabCalculator.convert(Lab: lab, workingSpace: workingSpace)
        self.init(cgColor: CGColor(srgbRed: rgb.red, green: rgb.green, blue: rgb.blue, alpha: 1.0))
    }
}
