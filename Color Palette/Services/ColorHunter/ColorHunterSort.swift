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
        self.rawValue.capitalized
    }
    
    static var uiCases: [Self] {
        [.new, .popular, .random]
    }
}
