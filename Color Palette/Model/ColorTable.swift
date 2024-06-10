//
//  ColorTable.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
//

import Foundation

enum ColorTable: String, CaseIterable, CustomStringConvertible, Identifiable {
    case hsb, rgb, lab, cmyk, hex
    
    var description: String {
        switch self {
        case .lab:
            "Lab"
        case .rgb:
            "RGB"
        case .hsb:
            "HSB"
        case .cmyk:
            "CMYK"
        case .hex:
            "HEX"
        }
    }
    
    var id: Self {
        self
    }
    
    var name: String {
        description
    }
}
