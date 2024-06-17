//
//  ColorPickerView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var color: Color
    let initial: Color?
    @Binding var colorSpace: DeviceColorSpace
    @Binding var colorTable: ColorTable
    @Binding var controller: PalettePickView.ColorController
    
    var body: some View {
        VStack {
            switch colorTable {
            case .hsb:
                HSBColorPicker(color: $color, initial: initial, colorSpace: $colorSpace, controller: $controller)
            case .rgb:
                RGBColorPicker(color: $color, initial: initial, colorSpace: $colorSpace, controller: $controller)
            case .lab:
                LabColorPicker(color: $color, initial: initial, colorSpace: $colorSpace, controller: $controller)
            case .cmyk:
                CMYKColorPicker(color: $color, initial: initial, colorSpace: $colorSpace, controller: $controller)
            case .hex:
                HEXColorPicker(color: $color, initial: initial, colorSpace: $colorSpace, controller: $controller)
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var color: Color = .green
        @State private var initial: Color = .green
        @State private var colorSpace: DeviceColorSpace = .displayP3
        @State private var colorTable: ColorTable = .rgb
        @State private var controller: PalettePickView.ColorController = .slider
        
        var body: some View {
            VStack {
                ColorPickerView(color: $color, initial: initial, colorSpace: $colorSpace, colorTable: $colorTable, controller: $controller)
                
                ColorPicker("Color", selection: $color, supportsOpacity: false)
            }
        }
    }
    
    return NavigationStack {
        PreviewWrapper()
    }
}
