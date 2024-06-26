//
//  HEXColorPicker.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 30.05.2024.
//

import SwiftUI

struct HEXColorPicker: View {
    @Binding var color: Color
    let initial: Color?
    @Binding var colorSpace: DeviceColorSpace
    @Binding var controller: PalettePickView.ColorController
    
    @State private var hex: String = ""
    
    init(color: Binding<Color>, initial: Color?, colorSpace: Binding<DeviceColorSpace>, controller: Binding<PalettePickView.ColorController>) {
        self._color = color
        self._colorSpace = colorSpace
        self.hex = color.wrappedValue.hex
        self._controller = controller
        self.initial = initial
    }
    
    var body: some View {
        VStack {
            Text("#" + hex)
                .font(.system(size: 24, design: .monospaced))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 40)
            
            HexPanelView(text: $hex)
                .padding(.top, 16)
        }
        .padding()
        .onChange(of: color) { _, newValue in
            guard controller != .slider else { return }
            hex = color.hex
        }
        .onChange(of: hex) { _, newHex in
            controller = .slider
            if let color = Color(hex: hex) {
                self.color = color
            }
        }
    }
    
    private func copyHex(color: Color) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = color.hex
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
                
                HEXColorPicker(color: $color, initial: color, colorSpace: .constant(.displayP3), controller: $controller)
                
            }
        }
    }
    return PreviewWrapper()
        .padding()
}
