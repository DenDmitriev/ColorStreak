//
//  ContrastValueView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 08.06.2024.
//

import SwiftUI

struct ContrastValueView: View {
    @Binding var contrast: ContrastWCAG?
    
    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text("Contrast Ratio")
                    
                    Text("WCAG")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                switch contrast {
                case .some(let contrast):
                    Text(contrast.contrast.formatted() + " : 1")
                        .foregroundStyle(.primary)
                        .fontWeight(.semibold)
                case .none:
                    Text("Empty")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .font(.system(size: 20, weight: .regular))
    }
}

#Preview {
    VStack {
        ContrastValueView(contrast: .constant(nil))
        ContrastValueView(contrast: .constant(.init(foreground: Color.white, background: Color.black)))
    }
}
