//
//  RectanglePaletteView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import SwiftUI

struct RectanglePaletteView: View {
    @Binding var colors: [Color]
    
    var body: some View {
        HStack(spacing: .zero) {
            ForEach(Array(zip(colors.indices, colors)), id: \.0) { _, color in
                Rectangle()
                    .fill(color)
            }
        }
    }
}

#Preview {
    RectanglePaletteView(colors: .constant([.red, .orange, .yellow, .green, .cyan, .blue, .purple]))
}
