//
//  HSBBrightnessSlider.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 27.05.2024.
//

import SwiftUI

struct HSBBrightnessSlider: View {
    @Binding var brightness: Double
    let initial: Double?
    @Binding var color: Color
    
    var body: some View {
        GradientSliderView(text: "Brightness", color: $color, level: $brightness, initial: initial, gradient: brightnessGradient, coordinate: .percent)
    }
    
    private var brightnessGradient: Binding<LinearGradient> {
        Binding {
            LinearGradient(colors: [
                Color(hue: color.hsb.hue, saturation: color.hsb.saturation, brightness: 0),
                Color(hue: color.hsb.hue, saturation: color.hsb.saturation, brightness: 1)
            ], startPoint: .leading, endPoint: .trailing)
        } set: { _ in }
    }
}
