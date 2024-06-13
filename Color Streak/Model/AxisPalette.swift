//
//  AxisPalette.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import Foundation

enum AxisPalette: String, Identifiable, CaseIterable {
    case horizontal = "Horizontal"
    case vertical = "Vertical"
    
    var id: Self {
        self
    }
    
    var name: String {
        switch self {
        case .horizontal:
            String(localized: "Horizontal")
        case .vertical:
            String(localized: "Vertical")
        }
    }
}
