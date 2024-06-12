//
//  ColorPickerView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var color: Color
    @Binding var colorSpace: DeviceColorSpace
    @Binding var colorTable: ColorTable
    @Binding var controller: PalettePickView.ColorController
    
    var body: some View {
        VStack {
            switch colorTable {
            case .hsb:
                HSBColorPicker(color: $color, colorSpace: $colorSpace, controller: $controller)
            case .rgb:
                RGBColorPicker(color: $color, colorSpace: $colorSpace, controller: $controller)
            case .lab:
                LabColorPicker(color: $color, colorSpace: $colorSpace, controller: $controller)
            case .cmyk:
                CMYKColorPicker(color: $color, colorSpace: $colorSpace, controller: $controller)
            case .hex:
                HEXColorPicker(color: $color, colorSpace: $colorSpace, controller: $controller)
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var color: Color = .red
        @State private var colorSpace: DeviceColorSpace = .displayP3
        @State private var colorTable: ColorTable = .hsb
        @State private var controller: PalettePickView.ColorController = .slider
        
        var body: some View {
            ColorPickerView(color: $color, colorSpace: $colorSpace, colorTable: $colorTable, controller: $controller)
        }
    }
    
    return NavigationStack {
        PreviewWrapper()
    }
}
