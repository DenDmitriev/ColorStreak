//
//  ColorSource.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 04.06.2024.
//

import Foundation

enum ColorSource: String, CaseIterable, Identifiable {
    case harmony = "Harmony"
    case random = "Random"
    case from = "From Color"
    case image = "Image"
    
    var id: String {
        self.rawValue
    }
    
    var name: String {
        self.rawValue
    }
    
    var systemImage: String {
        switch self {
        case .harmony:
            return "point.3.filled.connected.trianglepath.dotted"
        case .random:
            return "questionmark"
        case .from:
            return "point.bottomleft.forward.to.point.topright.scurvepath.fill"
        case .image:
            return "photo"
        }
    }
}
