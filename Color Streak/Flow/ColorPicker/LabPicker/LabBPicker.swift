//
//  LabBPicker.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import SwiftUI

struct LabBPicker: View {
    @Binding var blueYellowB: Double
    let initial: Double?
    @State private var bAxisColor: Color
    
    init(blueYellowB: Binding<Double>, initial: Double?) {
        self._blueYellowB = blueYellowB
        if let initial {
            self.initial = (initial + 100) / 200
        } else {
            self.initial = nil
        }
        self._bAxisColor = .init(wrappedValue: Color(lab: Lab(L: 75, a: 0, b: blueYellowB.wrappedValue)))
    }
    
    var body: some View {
        GradientSliderView(text: "Blue-Yellow", color: $bAxisColor, level: bAxis, initial: initial, gradient: bAxisGradient, coordinate: .balance)
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
            LabBPicker(blueYellowB: $blueYellowB, initial: 0)
        }
    }
    return PreviewWrapper()
}

