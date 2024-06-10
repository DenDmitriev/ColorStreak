//
//  NewColorHarmony.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 04.06.2024.
//

import SwiftUI

struct NewColorHarmony: View {
    @Binding var colors: [Color]
    @Binding var keyColor: Color
    
    @AppStorage(UserDefaultsKey.colorHarmony.key)
    private var colorHarmony: ColorHarmony = .triangular
    
    var body: some View {
        HStack {
            Text("Color Harmony")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Picker("Color Harmony", selection: $colorHarmony) {
                ForEach(ColorHarmony.allCases) { colorHarmony in
                    Text(colorHarmony.name)
                        .tag(colorHarmony)
                }
            }
        }
        
        ColorPicker(selection: $keyColor, supportsOpacity: false) {
            HStack {
                Text("KeyColor")
                
                Spacer()
                
                Button(action: {
                    keyColor = randomColor()
                }, label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 26))
                })
            }
        }
        .onChange(of: keyColor, { _, newKeyColor in
            generateColors(key: newKeyColor)
        })
        .onAppear {
            generateColors(key: keyColor)
        }
    }
    
    private func generateColors(key: Color) {
        Task(priority: .userInitiated) {
            let colors = colorHarmony.colors(initial: keyColor)
            DispatchQueue.main.async {
                self.colors = colors
            }
        }
    }
    
    private func randomColor() -> Color {
        func random() -> Double {
            Double(Int.random(in: 0...255)) / 255
        }
        return Color(red: random(), green: random(), blue:  random())
    }
}

#Preview {
    NewColorHarmony(colors: .constant(.init()), keyColor: .constant(.blue))
}
