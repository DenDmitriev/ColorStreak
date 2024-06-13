//
//  ColorHunterSort.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 12.06.2024.
//

import Foundation

enum ColorHunterSort: String, Identifiable, CaseIterable {
    case new, popular, random
    case empty
    
    var id: Self {
        self
    }
    
    var name: String {
        switch self {
        case .new:
            return String(localized: "New")
        case .popular:
            return String(localized: "Popular")
        case .random:
            return String(localized: "Random")
        case .empty:
            return self.rawValue
        }
    }
    
    static var uiCases: [Self] {
        [.new, .popular, .random]
    }
}
