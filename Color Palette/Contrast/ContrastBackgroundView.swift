//
//  ContrastBackgroundView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 09.06.2024.
//

import SwiftUI

struct ContrastBackgroundView: View {
    @Binding var colors: [Color]
    @State var background: Color
    
    var body: some View {
        VStack {
            HStack {
                Text("Contrast with \(background.description)")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 4) {
                    ForEach(colors, id: \.self) { color in
                        Circle()
                            .fill(color)
                    }
                }
                .frame(height: 8)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(background)
                        .frame(height: 20)
                }
                
            }
            
            HStack {
                LazyVStack {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(background)
                            .overlay {
                                Text(getContrast(left: color, right: background).formatted() + " : 1")
                                    .foregroundStyle(color)
                                    .font(.headline)
                                    .fontWeight(.heavy)
                            }
                            .frame(minHeight: 100)
                    }
                }
                
                LazyVStack {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color)
                            .overlay {
                                Text(getContrast(left: color, right: background).formatted() + " : 1")
                                    .foregroundStyle(background)
                                    .font(.headline)
                                    .fontWeight(.heavy)
                            }
                            .frame(minHeight: 100)
                    }
                }
            }
        }
    }
    
    private func getContrast(left: Color, right: Color) -> Double {
        ContrastWCAG(foreground: left, background: right).contrast
    }
}

#Preview {
    ContrastBackgroundView(colors: .constant(Palette.placeholder.colors), background: .white)
}
