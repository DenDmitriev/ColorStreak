//
//  CMYKCyanPicker.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import SwiftUI

struct CMYKCyanPicker: View {
    @Binding var cyan: Double
    @Binding var color: Color
    
    var body: some View {
        GradientSliderView(text: "Cyan", color: $color, level: $cyan, gradient: cyanGradient, coordinate: .percent)
    }
    
    private var cyanGradient: Binding<LinearGradient> {
        let cmyk = color.cmyk
        return Binding {
            LinearGradient(colors: [
                Color(cmyk: CMYK(cyan: 0, magenta: cmyk.magenta, yellow: cmyk.yellow, black: cmyk.black)),
                Color(cmyk: CMYK(cyan: 1, magenta: cmyk.magenta, yellow: cmyk.yellow, black: cmyk.black))
            ], startPoint: .leading, endPoint: .trailing)
        } set: { _ in }
    }
}
