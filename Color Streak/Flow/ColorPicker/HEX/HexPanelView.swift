//
//  HexPanelView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 07.06.2024.
//

import SwiftUI

struct HexPanelView: View {
    @Binding var text: String
    
    let columns = Array(repeating: GridItem(.flexible(minimum: 40, maximum: 80)), count: 6)
    
    let numbers = (Array(1...9) + [0]).map({ String($0) })
    let characters = ["A", "B", "C", "D", "E", "F"]
    
    var body: some View {
        HStack {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(characters + numbers, id: \.self) { button in
                    Button(button) {
                        text.append(button)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .disabled(text.count >= 6)
                
                Button("", systemImage: "delete.backward") {
                    backspace()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .disabled(text.isEmpty)
                
                Button("", systemImage: "doc.on.clipboard") {
                    paste()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .tint(.primary)
        .font(.system(size: 18, weight: .semibold))
    }
    
    private func backspace() {
        guard !text.isEmpty else { return }
        text.removeLast()
    }
    
    private func paste() {
        let pasteboard: UIPasteboard = UIPasteboard.general
        let formatter = HexFormatter()
        guard var hex = formatter.string(for: pasteboard.string ?? "") else { return }
        if hex.contains("#") {
            hex.removeFirst()
        }
        text = hex
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var text: String = ""
        
        var body: some View {
            VStack {
                Text(text)
                
                HexPanelView(text: $text)
            }
        }
    }
    return PreviewWrapper()
}
