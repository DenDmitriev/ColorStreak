//
//  ColorPaletteView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 28.05.2024.
//

import SwiftUI

struct ColorPaletteView: View {
    @ObservedObject var palette: Palette
    @Binding var selection: Int?
    @Environment(\.colorScheme) var colorScheme
    
    @State private var size: CGSize = .zero
    
    var body: some View {
        ZStack {
            HStack(spacing: .zero) {
                ForEach(Array(zip(palette.colors.indices, $palette.colors)), id: \.0) { index, color in
                    Rectangle()
                        .fill(color.wrappedValue)
                        .onTapGesture {
                            selection = index
                        }
                }
            }
            .readSize { size in
                self.size = size
            }
            
            Triangle()
                .fill(.regularMaterial)
                .frame(width: 24, height: 12)
                .position(position())
        }
    }
    
    private func position() -> CGPoint {
        let partWidth = size.width / Double(palette.colors.count)
        let x = partWidth * Double(selection ?? 0) + partWidth / 2
        let y = 6.0
        return .init(x: x, y: y)
    }
    
    private func colorSelection() -> some ShapeStyle {
        if let selection {
            let brightness = palette.colors[selection].hsb.brightness
            return AnyShapeStyle(brightness > 0.5 ? .black : .white)
        } else {
            return AnyShapeStyle(.clear)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        let palette: Palette = {
            let palette = Palette()
            palette.colors.append(.pink)
            palette.colors.append(.cyan)
            palette.colors.append(.orange)
            return palette
        }()
        
        @State private var selection: Int? = 1
        
        var body: some View {
            ColorPaletteView(palette: palette, selection: $selection)
        }
    }
    
    return PreviewWrapper()
}
