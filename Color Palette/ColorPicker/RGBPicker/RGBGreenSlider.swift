//
//  RGBGreenSlider.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 28.05.2024.
//

import SwiftUI

struct RGBGreenSlider: View {
    @Binding var green: Double
    @Binding var color: Color
    
    var body: some View {
        GradientSliderView(text: "Green", color: greenColor, level: $green, gradient: greenGradient, coordinate: .bits)
    }
    
    private var greenColor: Binding<Color> {
        let rgb = color.rgb
        return Binding(get: { Color(red: rgb.red, green: green, blue: rgb.blue)}, set: { _ in })
    }
    
    
    private var greenGradient: Binding<LinearGradient> {
        let rgb = color.rgb
        return Binding {
            LinearGradient(colors: [
                Color(red: rgb.red, green: 0, blue: rgb.blue),
                Color(red: rgb.red, green: 1, blue: rgb.blue)
            ], startPoint: .leading, endPoint: .trailing)
        } set: { _ in }
    }
}

#Preview {
    RGBGreenSlider(green: .constant(Color.green.rgb.green), color: .constant(.green))
}
