//
//  AdjustControlView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 06.06.2024.
//

import SwiftUI

struct AdjustControlView: View {
    @ObservedObject var palette: Palette
    @StateObject private var paletteInitial: Palette
    @State private var deltaHue: Double = 0
    @State private var deltaSaturation: Double = 0
    @State private var deltaBrightness: Double = 0
    @State private var deltaTemperature: Double = 0
    @State private var deltaTint: Double = 0
    
    init(palette: Palette) {
        self.palette = palette
        self._paletteInitial = .init(wrappedValue: palette.copy() as! Palette)
    }
    
    var body: some View {
        VStack {
            BalanceSlider(text: "Hue", level: $deltaHue, coordinate: .degree)
            BalanceSlider(text: "Saturation", level: $deltaSaturation, coordinate: .normal)
            BalanceSlider(text: "Brightness", level: $deltaBrightness, coordinate: .normal)
            BalanceSlider(text: "Temperature", level: $deltaTemperature, coordinate: .normal)
            BalanceSlider(text: "Tint", level: $deltaTint, coordinate: .normal)
        }
        .onChange(of: [deltaHue, deltaSaturation, deltaBrightness, deltaTemperature, deltaTint]) { newValue in
            guard !newValue.filter({ !$0.isZero }).isEmpty else {
                palette.colors = paletteInitial.colors
                return
            }
            let deltaHue = newValue[0]
            let deltaSaturation = newValue[1]
            let deltaBrightness = newValue[2]
            let deltaTemperature = newValue[3]
            let deltaTint = newValue[4]
            
            for index in palette.colors.indices {
                var color = paletteInitial.colors[index]
                
                // Correction Nodes
                adjustHSB(color: &color, hue: deltaHue, saturation: deltaSaturation, brightness: deltaBrightness)
                adjustTempTint(color: &color, temperature: deltaTemperature, tint: deltaTint)
                
                palette.colors[index] = color
            }
        }
    }
    
    private func adjustHSB(color: inout Color, hue deltaHue: Double, saturation deltaSaturation: Double, brightness deltaBrightness: Double) {
        let hsb = color.hsb
        let newHue = hsb.hue + deltaHue
        let newSaturation = hsb.saturation + deltaSaturation
        let newBrightness = hsb.brightness + deltaBrightness
        
        color = Color(hue: newHue, saturation: newSaturation, brightness: newBrightness)
    }
    
    /// shift adjust
    private func adjustTempTint(color: inout Color, temperature deltaTemperature: Double, tint deltaTint: Double) {
        let rgb = color.rgb
        let newRed = rgb.red + deltaTemperature
        let newGreen = rgb.green + deltaTint
        let newBlue = rgb.blue - deltaTemperature
        
        let rgbColorSpace = color.rgbColorSpace
        
        color = Color(rgbColorSpace, red: newRed, green: newGreen, blue: newBlue)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject var palette: Palette = .placeholder
        
        var body: some View {
            VStack(spacing: 24) {
                PaletteStackView(palette: palette, axis: .constant(.vertical))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                
                AdjustControlView(palette: palette)
            }
        }
    }
    return PreviewWrapper()
        .padding()
}
