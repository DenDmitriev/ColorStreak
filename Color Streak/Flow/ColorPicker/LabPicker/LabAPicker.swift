//
//  LabAPicker.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import SwiftUI

struct LabAPicker: View {
    @Binding var greenRedA: Double
    @State private var aAxisColor: Color
    
    init(greenRedA: Binding<Double>) {
        self._greenRedA = greenRedA
        self._aAxisColor = .init(wrappedValue: Color(lab: Lab(L: 75, a: greenRedA.wrappedValue, b: 0)))
    }
    
    var body: some View {
        GradientSliderView(text: "Green-Red", color: $aAxisColor, level: aAxis, gradient: aAxisGradient, coordinate: .balance)
    }
    
    private var aAxis: Binding<Double> {
        Binding(
            get: { (greenRedA + 100) / 200 },
            set: { value in
                greenRedA = value * 200 - 100
                aAxisColor = Color(lab: Lab(L: 75, a: greenRedA, b: 0))
            }
        )
    }
    
    private var aAxisGradient: Binding<LinearGradient> {
        Binding {
            return LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color(lab: Lab(L: 75, a: -100, b: 0)),
                        Color(lab: Lab(L: 75, a: 100, b: 0))
                    ]
                ),
                startPoint: .leading, endPoint: .trailing)
        } set: { _ in }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var greenRedA: Double = .zero
        
        var body: some View {
            LabAPicker(greenRedA: $greenRedA)
        }
    }
    return PreviewWrapper()
}
