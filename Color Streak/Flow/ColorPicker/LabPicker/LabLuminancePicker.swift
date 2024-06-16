//
//  LabLuminancePicker.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 28.05.2024.
//

import SwiftUI

struct LabLuminancePicker: View {
    @Binding var lightness: Double
    let initial: Double?
    @State private var lightnessColor: Color
    
    init(lightness: Binding<Double>, initial: Double?) {
        self._lightness = lightness
        if let initial {
            self.initial = initial / 100
        } else {
            self.initial = nil
        }
        self._lightnessColor = .init(wrappedValue: Color(lab: Lab(L: lightness.wrappedValue, a: 0, b: 0)))
    }
    
    var body: some View {
        GradientSliderView(text: "Luminance", color: $lightnessColor, level: lightnessAxis, initial: initial, gradient: lightnessGradient, coordinate: .normal)
    }
    
    private var lightnessAxis: Binding<Double> {
        Binding(
            get: { lightness / 100 },
            set: { value in
                lightness = value * 100
                lightnessColor = Color(lab: Lab(L: lightness, a: 0, b: 0))
            }
        )
    }
    
    private var lightnessGradient: Binding<LinearGradient> {
        Binding {
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color(lab: Lab(L: 0, a: 0, b: 0)),
                        Color(lab: Lab(L: 100, a: 0, b: 0))
                    ]
                ),
                startPoint: .leading, endPoint: .trailing)
        } set: { _ in }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var lightness: Double = 50
        
        var body: some View {
            LabLuminancePicker(lightness: $lightness, initial: lightness)
            
        }
    }
    return PreviewWrapper()
}
