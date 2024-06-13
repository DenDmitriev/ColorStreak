//
//  PaletteStackView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 06.06.2024.
//

import SwiftUI

struct PaletteStackView: View {
    enum AxisPalette {
        case horizontal
        case vertical
    }
    
    @ObservedObject var palette: Palette
    @Binding var axis: AxisPalette
    
    var body: some View {
        switch axis {
        case .horizontal:
            HStack(spacing: .zero) {
                ForEach(Array(zip(palette.colors.indices, $palette.colors)), id: \.0) { index, color in
                    Rectangle()
                        .fill(color.wrappedValue)
                }
            }
        case .vertical:
            VStack(spacing: .zero) {
                ForEach(Array(zip(palette.colors.indices, $palette.colors)), id: \.0) { index, color in
                    Rectangle()
                        .fill(color.wrappedValue)
                }
            }
        }
    }
}

#Preview {
    PaletteStackView(palette: .placeholder, axis: .constant(.vertical))
}
