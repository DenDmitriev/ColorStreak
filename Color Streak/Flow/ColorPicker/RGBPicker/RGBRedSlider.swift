//
//  RGBRedSlider.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 28.05.2024.
//

import SwiftUI

struct RGBRedSlider: View {
    @Binding var red: Double
    let initial: Double?
    @Binding var color: Color
    
    var body: some View {
        GradientSliderView(text: "Red", color: redColor, level: $red, initial: initial, gradient: redGradient, coordinate: .bits)
    }
    
    private var redColor: Binding<Color> {
        let rgb = color.rgb
        return Binding(get: { Color(red: red, green: rgb.green, blue: rgb.blue)}, set: { _ in })
    }
    
    
    private var redGradient: Binding<LinearGradient> {
        let rgb = color.rgb
        return Binding {
            LinearGradient(colors: [
                Color(red: 0, green: rgb.green, blue: rgb.blue),
                Color(red: 1, green: rgb.green, blue: rgb.blue)
            ], startPoint: .leading, endPoint: .trailing)
        } set: { _ in }
    }
}

#Preview {
    RGBRedSlider(red: .constant(Color.red.rgb.red), initial: 1, color: .constant(.red))
}
