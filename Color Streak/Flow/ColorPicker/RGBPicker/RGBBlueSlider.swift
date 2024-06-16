//
//  RGBBlueSlider.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 28.05.2024.
//

import SwiftUI

struct RGBBlueSlider: View {
    @Binding var blue: Double
    let initial: Double?
    @Binding var color: Color
    
    var body: some View {
        GradientSliderView(text: "Red", color: blueColor, level: $blue, initial: initial, gradient: blueGradient, coordinate: .bits)
    }
    
    private var blueColor: Binding<Color> {
        let rgb = color.rgb
        return Binding(get: { Color(red: rgb.red, green: rgb.green, blue: blue)}, set: { _ in })
    }
    
    
    private var blueGradient: Binding<LinearGradient> {
        let rgb = color.rgb
        return Binding {
            LinearGradient(colors: [
                Color(red: rgb.red, green: rgb.green, blue: 0),
                Color(red: rgb.red, green: rgb.green, blue: 1)
            ], startPoint: .leading, endPoint: .trailing)
        } set: { _ in }
    }
}

#Preview {
    RGBBlueSlider(blue: .constant(Color.blue.rgb.blue), initial: 1, color: .constant(.blue))
}
