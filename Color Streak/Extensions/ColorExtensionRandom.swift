//
//  ColorExtensionRandom.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 07.06.2024.
//

import SwiftUI

extension Color {
    static var random: Self {
        func random() -> Double {
            Double(Int.random(in: 0...255)) / 255
        }
        
        return Color(red: random(), green: random(), blue: random())
    }
}

