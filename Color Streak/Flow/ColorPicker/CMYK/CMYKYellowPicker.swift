//
//  CMYKYellowPicker.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import SwiftUI

struct CMYKYellowPicker: View {
    @Binding var yellow: Double
    @Binding var color: Color

    
    var body: some View {
        GradientSliderView(text: "Yellow", color: $color, level: $yellow, gradient: yellowGradient, coordinate: .percent)
    }
    
    private var yellowGradient: Binding<LinearGradient> {
        let cmyk = color.cmyk
        return Binding {
            LinearGradient(colors: [
                Color(cmyk: CMYK(cyan: cmyk.cyan, magenta: cmyk.magenta, yellow: 0, black: cmyk.black)),
                Color(cmyk: CMYK(cyan: cmyk.cyan, magenta: cmyk.magenta, yellow: 1, black: cmyk.black))
            ], startPoint: .leading, endPoint: .trailing)
        } set: { _ in }
    }
}
