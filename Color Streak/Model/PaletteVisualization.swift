//
//  PaletteVisualization.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import Foundation

enum PaletteVisualization: String, Identifiable, CaseIterable {
    case rectangle = "rectangle"
    case liquid = "liquid"
    case metaBall = "metaball"
    
    var id: Self {
        self
    }
    
    var name: String {
        switch self {
        case .rectangle:
            String(localized: "Rectangle")
        case .liquid:
            String(localized: "Liquid")
        case .metaBall:
            String(localized: "Metaball")
        }
    }
}
