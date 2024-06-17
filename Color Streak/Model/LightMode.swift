//
//  LightMode.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 17.06.2024.
//

import Foundation

enum LightMode: String, CaseIterable, Identifiable {
    case light, dark, automatic
    
    var id: String {
        self.rawValue
    }
    
    var systemImage: String {
        switch self {
        case .light:
            "sun.min.fill"
        case .dark:
            "moon.fill"
        case .automatic:
            "arrow.triangle.2.circlepath"
        }
    }
    
    var name: String {
        switch self {
        case .light:
            String(localized: "Light")
        case .dark:
            String(localized: "Dark")
        case .automatic:
            String(localized: "Automatic")
        }
    }
}
