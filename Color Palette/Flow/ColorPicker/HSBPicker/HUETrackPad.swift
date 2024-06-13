//
//  HUEColorPicker.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 19.05.2024.
//

import SwiftUI

struct HUETrackPad: View {
    @Binding var hue: Double
    @Binding var color: Color
    
    @State private var position: CGPoint = .zero
    @State private var pickerDiameter: CGFloat = 24
    let pickerDiameterInitial: CGFloat = 24
    
    @State private var size: CGSize = .zero
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(saturationGradient.wrappedValue)
                .drawingGroup(opaque: false, colorMode: .extendedLinear)
            
            Rectangle()
                .fill(brightnessGradient.wrappedValue)
                .blendMode(.multiply)
            
            KnobView(color: $color)
                .frame(width: pickerDiameter)
                .position(position)
        }
        .frame(height: size.width)
        .readSize { size in
            self.size = size
        }
        .padding(pickerDiameterInitial / 2)
        .gesture(DragGesture()
            .onChanged { value in
                if pickerDiameter == pickerDiameterInitial {
                    pickerDiameter = pickerDiameterInitial * 3
                }
                
                let x = max(min(value.location.x - pickerDiameterInitial / 2, size.width - 1), 0)
                let y = max(min(value.location.y - pickerDiameterInitial / 2, size.height - 1), 0)
                
                position = CGPoint(x: x, y: y)
            }
            .onEnded { value in
                pickerDiameter = pickerDiameterInitial
            }
        )
        .animation(.easeInOut, value: pickerDiameter)
        .onTapGesture { location in
            let x = location.x - pickerDiameter / 2
            let y = location.y - pickerDiameter / 2
            position = CGPoint(x: x, y: y)
        }
        .onChange(of: position) { _, newPosition in
            let saturation = newPosition.x / size.width
            let brightness = 1 - newPosition.y / size.height
            color = Color(hue: hue, saturation: saturation, brightness: brightness)
        }
        .onAppear {
            updatePosition(size: size)
        }
    }
    
    private var brightnessGradient: Binding<LinearGradient> {
        let gradient = LinearGradient(
            gradient: Gradient(
                colors: [
                    Color(hue: hue, saturation: 0, brightness: 0, opacity: 0),
                    Color(hue: hue, saturation: 0, brightness: 0, opacity: 1)]
            ),
            startPoint: .top, endPoint: .bottom
        )
        return .init(get: { gradient }, set: { _ in })
    }
    
    private var saturationGradient: Binding<LinearGradient> {
        let gradient = LinearGradient(
            colors: [
                Color(hue: hue, saturation: 0, brightness: 1),
                Color(hue: hue, saturation: 1, brightness: 1)
            ],
            startPoint: .leading, endPoint: .trailing
        )
        
        return .init(get: { gradient }, set: { _ in })
    }
    
    private func updatePosition(size: CGSize) {
        let xLocation = color.hsb.saturation * size.width
        let xCorrected = max(min(xLocation, size.width), 0)
        let yLocation = (1 - color.hsb.brightness) * size.height
        let yCorrected = max(min(yLocation, size.height), 0)
        
        position = CGPoint(x: xCorrected, y: yCorrected)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var hue: Double = 0
        @State private var color: Color = Color(.displayP3, red: 1, green: 0, blue: 0)
        
        var body: some View {
            HUETrackPad(hue: $hue, color: $color)
        }
    }
    return PreviewWrapper()
}
