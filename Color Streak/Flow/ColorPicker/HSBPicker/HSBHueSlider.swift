//
//  HSBHueSlider.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 27.05.2024.
//

import SwiftUI

struct HSBHueSlider: View {
    @Binding var hue: Double
    let initial: Double?
    @State private var hueColor: Color
    
    init(hue: Binding<Double>, initial: Double?) {
        self._hue = hue
        self.initial = initial
        self._hueColor = .init(wrappedValue: Color(hue: hue.wrappedValue, saturation: 1, brightness: 1))
    }
    
    var body: some View {
        GradientSliderView(text: "Hue", color: $hueColor, level: $hue, initial: initial, gradient: hueGradient, coordinate: .degree)
            .onChange(of: hue) { _, newHue in
                hueColor = Color(hue: newHue, saturation: 1, brightness: 1)
            }
    }
    
    private var hueGradient: Binding<LinearGradient> {
        Binding {
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color(red: 1, green: 0, blue: 0),
                        Color(red: 1, green: 1, blue: 0),
                        Color(red: 0, green: 1, blue: 0),
                        Color(red: 0, green: 1, blue: 1),
                        Color(red: 0, green: 0, blue: 1),
                        Color(red: 1, green: 0, blue: 1),
                        Color(red: 1, green: 0, blue: 0)
                    ]
                ),
                startPoint: .leading, endPoint: .trailing)
        } set: { _ in }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var hue: Double = .zero
        
        var body: some View {
            HSBHueSlider(hue: $hue, initial: hue)
        }
    }
    return PreviewWrapper()
        .padding()
}
