//
//  HSBSaturationSlider.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 27.05.2024.
//

import SwiftUI

struct HSBSaturationSlider: View {
    @Binding var saturation: Double
    let initial: Double?
    @Binding var color: Color
    
    var body: some View {
        GradientSliderView(text: "Saturation", color: $color, level: $saturation, initial: initial, gradient: saturationGradient, coordinate: .percent)
    }
    
    private var saturationGradient: Binding<LinearGradient> {
        Binding {
            LinearGradient(colors: [
                Color(hue: color.hsb.hue, saturation: 0, brightness: color.hsb.brightness),
                Color(hue: color.hsb.hue, saturation: 1, brightness: color.hsb.brightness)
            ], startPoint: .leading, endPoint: .trailing)
        } set: { _ in }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var saturation: Double = .zero
        @State var color: Color = .yellow
        
        var body: some View {
            HSBSaturationSlider(saturation: $saturation, initial: 0, color: $color)
        }
    }
    return PreviewWrapper()
        .padding()
}

