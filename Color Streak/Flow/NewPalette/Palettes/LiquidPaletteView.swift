//
//  LiquidPaletteView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 02.06.2024.
//

import SwiftUI
import Liquid

struct LiquidPaletteView: View {
    @Binding var colors: [Color]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear
                
                ForEach(Array(zip(colors.indices, colors)), id: \.0) { index, color in
                    let count = colors.count - 1
                    let invertIndex = count - index
                    let width = geometry.size.width / CGFloat(count) * CGFloat(invertIndex)
                    Liquid()
                        .frame(width: width, height: width)
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(color)
                }
            }
        }
    }
}

#Preview {
    LiquidPaletteView(colors: .constant([.red, .orange, .yellow, .green, .cyan, .blue, .purple]))
}
