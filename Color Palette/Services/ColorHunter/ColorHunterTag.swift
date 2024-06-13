//
//  ColorHunterTag.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 12.06.2024.
//

import Foundation

enum ColorHunterTag: String, Identifiable, CaseIterable, Equatable {
    case pastel, vintage, retro, neon, gold, light, dark, warm, cold, summer, fall, winter, spring, happy, nature, earth, night, space, rainbow, gradient, sunset, sky, sea, kids, skin, food, cream, coffee, wedding, christmas, halloween
    case blue, teal, mint, green, sage, yellow, beige, brown, orange, peach, red, maroon, pink, purple, navy, black, grey, white
    
    enum Kind: String, Identifiable, CaseIterable, Equatable {
        case colors, collections
        
        var id: Self {
            self
        }
        
        var name: String {
            self.rawValue.capitalized
        }
    }
    
    var kind: Kind {
        switch self {
        case .pastel, .vintage, .retro, .neon, .gold, .light, .dark, .warm, .cold, .summer, .fall, .winter, .spring, .happy, .nature, .earth, .night, .space, .rainbow, .gradient, .sunset, .sky, .sea, .kids, .skin, .food, .cream, .coffee, .wedding, .christmas, .halloween:
            return .collections
        case .blue, .teal, .mint, .green, .sage, .yellow, .beige, .brown, .orange, .peach, .red, .maroon, .pink, .purple, .navy, .black, .grey, .white:
            return .colors
        }
    }
    
    var id: Self {
        self
    }
    
    var name: String {
        self.rawValue.capitalized
    }
    
    var hex: String? {
        switch self {
        case .blue:
            "5BA3F8"
        case .teal:
            "53B6A8"
        case .mint:
            "9FF0BC"
        case .green:
            "8EDA50"
        case .sage:
            "B2BE92"
        case .yellow:
            "FAE383"
        case .beige:
            "ECD3A0"
        case .brown:
            "916C3D"
        case .orange:
            "F0985E"
        case .peach:
            "E0A69E"
        case .red:
            "EB4B42"
        case .maroon:
            "9A322C"
        case .pink:
            "EE7CB9"
        case .purple:
            "B258D9"
        case .navy:
            "424791"
        case .black:
            "333333"
        case .grey:
            "DCDCDC"
        case .white:
            "FFFFFF"
        default:
            nil
        }
    }
}
