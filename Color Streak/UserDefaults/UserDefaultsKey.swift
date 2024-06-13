//
//  UserDefaultsKeys.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 19.05.2024.
//

import Foundation

enum UserDefaultsKey: String {
    case deviceColorSpace, isDarkMode, colorHarmony, paletteVisualization, shareColor, colorTable, widthPalette, heightPalette
    case colorSource
    
    var key: String {
        self.rawValue
    }
}
