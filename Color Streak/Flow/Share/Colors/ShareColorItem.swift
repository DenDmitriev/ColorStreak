//
//  ShareColorItem.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import SwiftUI

struct ShareColorItem: View {
    @State var color: Color
    @Binding var colorTable: ColorTable
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(height: 60)
            
            Group {
                switch colorTable {
                case .hsb:
                    Text(color.hsb.description)
                case .rgb:
                    Text(color.rgb.description)
                case .lab:
                    Text(color.lab.description)
                case .cmyk:
                    Text(color.cmyk.description)
                case .hex:
                    Text(color.hex, format: .hex)
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .font(.system(.headline, design: .monospaced))
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ShareColorItem(color: .red, colorTable: .constant(.hex))
}
