//
//  ColorSpaceView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 19.05.2024.
//

import SwiftUI

struct HSBColorPicker: View {
    @Binding var color: Color
    @Binding var colorSpace: DeviceColorSpace
    @Binding var controller: PalettePickView.ColorController
    
    @State private var hue: Double
    @State private var saturation: Double
    @State private var brightness: Double
    
    @State private var isControl = true
    
    init(color: Binding<Color>, colorSpace: Binding<DeviceColorSpace>, controller: Binding<PalettePickView.ColorController>) {
        self._color = color
        self._colorSpace = colorSpace
        let hsb = color.wrappedValue.hsb
        self.hue = hsb.hue
        self.saturation = hsb.saturation
        self.brightness = hsb.brightness
        self._controller = controller
    }
    
    var body: some View {
        VStack(spacing: 14) {
            HSBHueSlider(hue: $hue)
            HSBSaturationSlider(saturation: $saturation, color: $color)
            HSBBrightnessSlider(brightness: $brightness, color: $color)
        }
        .onChange(of: color, { _, newColor in
            guard controller != .slider else { return }
            let hsb = newColor.hsb
            self.hue = hsb.hue
            self.saturation = hsb.saturation
            self.brightness = hsb.brightness
        })
        .onChange(of: [hue, saturation, brightness]) { _, newValue in
            guard controller == .slider else { return }
            let hue = newValue[0]
            let saturation = newValue[1]
            let brightness = newValue[2]
            
            color = Color(hue: hue, saturation: saturation, brightness: brightness)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var color: Color = .red
        @State var controller: PalettePickView.ColorController = .slider
        
        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(color)
                
                HSBColorPicker(color: $color, colorSpace: .constant(.displayP3), controller: $controller)
            }
        }
    }
    return PreviewWrapper()
        .padding()
}
