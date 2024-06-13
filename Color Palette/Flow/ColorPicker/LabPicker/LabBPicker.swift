//
//  LabBPicker.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import SwiftUI

struct LabBPicker: View {
    @Binding var blueYellowB: Double
    @State private var bAxisColor: Color
    
    init(blueYellowB: Binding<Double>) {
        self._blueYellowB = blueYellowB
        self._bAxisColor = .init(wrappedValue: Color(lab: Lab(L: 75, a: 0, b: blueYellowB.wrappedValue)))
    }
    
    var body: some View {
        GradientSliderView(text: "Blue-Yellow", color: $bAxisColor, level: bAxis, gradient: bAxisGradient, coordinate: .balance)
    }
    
    private var bAxis: Binding<Double> {
        Binding(
            get: { (blueYellowB + 100) / 200 },
            set: { value in
                blueYellowB = value * 200 - 100
                bAxisColor = Color(lab: Lab(L: 75, a: 0, b: blueYellowB))
            }
        )
    }
    
    private var bAxisGradient: Binding<LinearGradient> {
        Binding {
            return LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color(lab: Lab(L: 75, a: 0, b: -100)),
                        Color(lab: Lab(L: 75, a: 0, b: 100))
                    ]
                ),
                startPoint: .leading, endPoint: .trailing)
        } set: { _ in }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var blueYellowB: Double = 0
        
        var body: some View {
            LabBPicker(blueYellowB: $blueYellowB)
        }
    }
    return PreviewWrapper()
}

