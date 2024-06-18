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
    
    private let redInitial: Double?
    private let greenInitial: Double?
    private let blueInitial: Double?
    
    init(color: Binding<Color>, initial: Color?, colorSpace: Binding<DeviceColorSpace>, controller: Binding<PalettePickView.ColorController>) {
        self._color = color
        self._colorSpace = colorSpace
        let rgb = color.wrappedValue.rgb
        self.red = rgb.red
        self.green = rgb.green
        self.blue = rgb.blue
        self._controller = controller
        let rgbInitial = initial?.rgb
        self.redInitial = rgbInitial?.red
        self.greenInitial = rgbInitial?.green
        self.blueInitial = rgbInitial?.blue
    }
    
    var body: some View {
        VStack(spacing: 14) {
            RGBRedSlider(red: $red, initial: redInitial, color: $color)
            RGBGreenSlider(green: $green, initial: greenInitial, color: $color)
            RGBBlueSlider(blue: $blue, initial: blueInitial, color: $color)
        }
        .onChange(of: color, { _, newColor in
            guard controller != .slider else { return }
            let rgb = color.rgb
            self.red = rgb.red
            self.green = rgb.green
            self.blue = rgb.blue
        })
        .onChange(of: [red, green, blue]) { _, newValue in
            controller = .slider
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
                
                RGBColorPicker(color: $color, initial: color, colorSpace: .constant(.displayP3), controller: $controller)
            }
        }
    }
    return PreviewWrapper()
        .padding()
}
