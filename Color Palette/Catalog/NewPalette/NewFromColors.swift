//
//  NewFromColors.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 04.06.2024.
//

import SwiftUI

struct NewFromColors: View {
    @Binding var colors: [Color]
    @Binding var keyColor: Color
    @EnvironmentObject private var coordinator: Coordinator<CatalogRouter, CatalogError>
    
    var body: some View {
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
        .alert(isPresented: $coordinator.hasError, error: coordinator.error) {
            Button("Ok", action: { coordinator.dismissErrorAlert() })
        }
        .onChange(of: keyColor, { _, newValue in
            Task(priority: .userInitiated) {
                await getColors(from: newValue)
            }
        })
        .task {
            await getColors(from: keyColor)
        }
    }
    
    private func randomColor() -> Color {
        func random() -> Double {
            Double(Int.random(in: 0...255)) / 255
        }
        return Color(red: random(), green: random(), blue:  random())
    }
    
    private func getColors(from: Color) async {
        let result = await PaletteAPI.getPalette(method: .keyColor(hex: from.hex))
        
        switch result {
        case .success(let palette):
            DispatchQueue.main.async {
                self.colors = palette.colors
            }
        case .failure(let error):
            DispatchQueue.main.async {
                coordinator.presentAlert(error: CatalogError.map(description: error.localizedDescription))
            }
            print(error.localizedDescription)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var colors: [Color] = .init()
        @State private var keyColor: Color = .red
        
        var body: some View {
            VStack {
                NewFromColors(colors: $colors, keyColor: $keyColor)
                
                HStack {
                    ForEach(colors, id: \.self) { color in
                        Rectangle()
                            .fill(color)
                    }
                }
            }
        }
    }
    
    return PreviewWrapper()
        .environmentObject(Coordinator<CatalogRouter, CatalogError>())
}
