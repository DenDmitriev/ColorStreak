//
//  MetaBallPaletteView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import SwiftUI

struct MetaBallPaletteView: View {
    @Binding var colors: [Color]
    
    var body: some View {
        ZStack {
            ForEach(Array(zip(colors.indices, $colors)), id: \.0) { _, color in
                CloudedMetaBallView(color: color)
            }
        }
    }
}

#Preview {
    MetaBallPaletteView(colors: .constant([.red, .orange, .yellow, .green, .cyan, .blue, .purple]))
}
