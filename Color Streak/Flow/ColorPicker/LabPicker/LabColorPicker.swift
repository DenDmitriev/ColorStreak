//
//  LabColorPicker.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 28.05.2024.
//

import SwiftUI

struct LabColorPicker: View {
    @Binding var color: Color
    @Binding var colorSpace: DeviceColorSpace
    @Binding var controller: PalettePickView.ColorController
    
    @State private var lightness: Double
    @State private var greenRedA: Double
    @State private var blueYellowB: Double
    
    init(color: Binding<Color>, colorSpace: Binding<DeviceColorSpace>, controller: Binding<PalettePickView.ColorController>) {
        self._color = color
        self._colorSpace = colorSpace
        let lab = color.wrappedValue.lab
        self.lightness = lab.L
        self.greenRedA = lab.a
        self.blueYellowB = lab.b
        self._controller = controller
    }
    
    var body: some View {
        VStack(spacing: 14) {
            LabLuminancePicker(lightness: $lightness)
            LabAPicker(greenRedA: $greenRedA)
            LabBPicker(blueYellowB: $blueYellowB)
        }
        .onChange(of: color, { _, newColor in
//            guard controller != .slider else { return }
            let lab = color.lab
            self.lightness = lab.L
            self.greenRedA = lab.a
            self.blueYellowB = lab.b
        })
        .onChange(of: [lightness, greenRedA, blueYellowB]) { _, newValue in
            guard controller == .slider else { return }
            let lightness = newValue[0]
            let greenRedA = newValue[1]
            let blueYellowB = newValue[2]
            
            let lab = Lab(L: lightness, a: greenRedA, b: blueYellowB)
            
            color = Color(lab: lab, workingSpace: colorSpace.rgbWorkingSpace)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var color: Color = Color(lab: Lab(L: 50, a: -50, b: 50))
        @State var controller: PalettePickView.ColorController = .slider
        
        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(color)
                
                LabColorPicker(color: $color, colorSpace: .constant(.displayP3), controller: $controller)
            }
        }
    }
    return PreviewWrapper()
        .padding()
}
