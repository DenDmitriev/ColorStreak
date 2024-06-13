//
//  UIColorExtensionRGB.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 05.06.2024.
//

import SwiftUI

extension UIColor {
    var rgb: RGB {
        RGB(cgColor: self.cgColor)
    }
    
    var alpha: CGFloat {
        self.cgColor.alpha
    }
    
    var alpha255: Int {
        Int(max(min(alpha * 255, 255), 0))
    }
}
