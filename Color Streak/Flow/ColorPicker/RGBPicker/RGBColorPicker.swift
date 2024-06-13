//
//  RGBColorPicker.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 28.05.2024.
//

import SwiftUI

struct RGBColorPicker: View {
    @Binding var color: Color
    @Binding var colorSpace: DeviceColorSpace
    @Binding var controller: PalettePickView.ColorController
    
    @State private var red: Double
    @State private var green: Double
    @State private var blue: Double
    
    init(color: Binding<Color>, colorSpace: Binding<DeviceColorSpace>, controller: Binding<PalettePickView.ColorController>) {
        self._color = color
        self._colorSpace = colorSpace
        let rgb = color.wrappedValue.rgb
        self.red = rgb.red
        self.green = rgb.green
        self.blue = rgb.blue
        self._controller = controller
    }
    
    var body: some View {
        VStack(spacing: 14) {
            RGBRedSlider(red: $red, color: $color)
            RGBGreenSlider(green: $green, color: $color)
            RGBBlueSlider(blue: $blue, color: $color)
        }
        .onChange(of: color, { _, newColor in
            guard controller != .slider else { return }
            let rgb = color.rgb
            self.red = rgb.red
            self.green = rgb.green
            self.blue = rgb.blue
        })
        .onChange(of: [red, green, blue]) { _, newValue in
            guard controller == .slider else { return }
            let red = newValue[0]
            let green = newValue[1]
            let blue = newValue[2]
            
            color = Color(colorSpace.rgbColorSpace, red: red, green: green, blue: blue)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var color: Color = Color(.displayP3, red: 0.5, green: 0.9, blue: 0.1)
        @State var controller: PalettePickView.ColorController = .slider
        
        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(color)
                
                RGBColorPicker(color: $color, colorSpace: .constant(.displayP3), controller: $controller)
            }
        }
    }
    return PreviewWrapper()
        .padding()
}
