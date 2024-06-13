//
//  PaletteVisualization.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import Foundation

enum PaletteVisualization: String, Identifiable, CaseIterable {
    case rectangle = "Rectangle"
    case liquid = "Liquid"
    case metaBall = "Metaball"
    
    var id: Self {
        self
    }
    
    var name: String {
        self.rawValue
    }
}
