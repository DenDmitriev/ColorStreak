//
//  ContrastPickerView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 08.06.2024.
//

import SwiftUI

struct ContrastPickerView: View {
    @Binding var foreground: Color
    @Binding var background: Color
    
    @State var showForegroundPicker = false
    @State var showBackgroundPicker = false
    
    var body: some View {
        ZStack {
            Button {
                showBackgroundPicker.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .fill(background)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 100)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            Button {
                showForegroundPicker.toggle()
            } label: {
                Circle()
                    .fill(foreground)
                    .frame(height: 66)
            }
            .clipShape(Circle())
            .offset(x: 32, y: 24)
        }
        .sheet(isPresented: $showBackgroundPicker) {
            ColorPickerPanel(color: $background, isShow: $showBackgroundPicker)
        }
        .sheet(isPresented: $showForegroundPicker) {
            ColorPickerPanel(color: $foreground, isShow: $showForegroundPicker)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var foreground: Color = .blue
        @State var background: Color = .yellow
        
        var body: some View {
            ContrastPickerView(foreground: $foreground, background: $background)
        }
    }
    return PreviewWrapper()
}
