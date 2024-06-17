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
    let hueInitial: Double?
    let saturationInitial: Double?
    let brightnessInitial: Double?
    
    @State private var isControl = true
    
    init(color: Binding<Color>, initial: Color?, colorSpace: Binding<DeviceColorSpace>, controller: Binding<PalettePickView.ColorController>) {
        self._color = color
        self._colorSpace = colorSpace
        let hsb = color.wrappedValue.hsb
        self.hue = hsb.hue
        self.saturation = hsb.saturation
        self.brightness = hsb.brightness
        self._controller = controller
        let hsbInitial = initial?.hsb
        self.hueInitial = hsbInitial?.hue
        self.saturationInitial = hsbInitial?.saturation
        self.brightnessInitial = hsbInitial?.brightness
    }
    
    var body: some View {
        VStack(spacing: 14) {
            HSBHueSlider(hue: $hue, initial: hueInitial)
            HSBSaturationSlider(saturation: $saturation, initial: saturationInitial, color: $color)
            HSBBrightnessSlider(brightness: $brightness, initial: brightnessInitial, color: $color)
        }
        .onChange(of: color, { _, newColor in
            updateValues(color: newColor)
        })
        .onChange(of: [hue, saturation, brightness]) { _, newValue in
            controller = .slider
            updateColor(hue: newValue[0], saturation: newValue[1], brightness: newValue[2])
        }
    }
    
    private func updateColor(hue: Double, saturation: Double, brightness: Double) {
        color = Color(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    private func updateValues(color: Color) {
        guard controller != .slider else { return }
        let hsb = color.hsb
        self.hue = hsb.hue
        self.saturation = hsb.saturation
        self.brightness = hsb.brightness
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var color: Color = .red
        let initial: Color = .red
        @State var controller: PalettePickView.ColorController = .slider
        
        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(color)
                
                HSBColorPicker(color: $color, initial: initial, colorSpace: .constant(.displayP3), controller: $controller)
            }
        }
    }
    return PreviewWrapper()
        .padding()
}
