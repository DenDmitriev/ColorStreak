//
//  CMYKMagentaPicker.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import SwiftUI

struct CMYKMagentaPicker: View {
    @Binding var magenta: Double
    @Binding var color: Color
    
    var body: some View {
        GradientSliderView(text: "Magent", color: $color, level: $magenta, gradient: magentaGradient, coordinate: .percent)
    }
    
    private var magentaGradient: Binding<LinearGradient> {
        let cmyk = color.cmyk
        return Binding {
            LinearGradient(colors: [
                Color(cmyk: CMYK(cyan: cmyk.cyan, magenta: 0, yellow: cmyk.yellow, black: cmyk.black)),
                Color(cmyk: CMYK(cyan: cmyk.cyan, magenta: 1, yellow: cmyk.yellow, black: cmyk.black))
            ], startPoint: .leading, endPoint: .trailing)
        } set: { _ in }
    }
}
