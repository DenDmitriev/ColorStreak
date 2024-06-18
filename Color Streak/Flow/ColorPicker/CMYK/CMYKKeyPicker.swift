//
//  CMYKKeyPicker.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import SwiftUI

struct CMYKKeyPicker: View {
    @Binding var key: Double
    @Binding var color: Color
    let initial: Double?
    
    var body: some View {
        GradientSliderView(text: "Key", color: $color, level: $key, initial: initial, gradient: keyGradient, coordinate: .percent)
    }
    
    private var keyGradient: Binding<LinearGradient> {
        let cmyk = color.cmyk
        return Binding {
            LinearGradient(colors: [
                Color(cmyk: CMYK(cyan: cmyk.cyan, magenta: cmyk.magenta, yellow: cmyk.yellow, black: 0)),
                Color(cmyk: CMYK(cyan: cmyk.cyan, magenta: cmyk.magenta, yellow: cmyk.yellow, black: 1))
            ], startPoint: .leading, endPoint: .trailing)
        } set: { _ in }
    }
}
