//
//  ContrastPreviewView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 08.06.2024.
//

import SwiftUI

struct ContrastPreviewView<Content>: View where Content: View {
    @Binding var background: Color
    @Binding var foreground: Color
    
    let compliance: ContrastWCAG.Compliance
    let element: ContrastWCAG.Compliance.Element
    
    let content: () -> Content
    
    @State private var result: Bool = false
    
    var body: some View {
        content()
            .frame(maxWidth: .infinity)
            .foregroundStyle(foreground)
            .padding(40)
            .background(background)
            .overlay(alignment: .topTrailing) {
                Button("", systemImage: "arrow.left.arrow.right.circle.fill", action: invert)
                    .font(.title2)
                    .padding(8)
                    .foregroundStyle(.regularMaterial)
            }
            .overlay(alignment: .bottomLeading) {
                Image(systemName: result ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(result ? .green : .red)
                    .font(.title2)
                    .padding(8)
            }
            .onChange(of: [background, foreground]) { _, newColors in
                let background = newColors[0]
                let foreground = newColors[1]
                let result = ContrastWCAG(foreground: foreground, background: background).checker(compliance: compliance, for: element)
                self.result = result
            }
    }
    
    private func invert() {
        let temp = background
        self.background = foreground
        self.foreground = temp
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var background: Color = .black
        @State private var foreground: Color = .white
        
        var body: some View {
            ContrastPreviewView(
                background: $background,
                foreground: $foreground,
                compliance: .AA,
                element: .uiComponents
            ) {
                Image(systemName: "apple.logo")
            }
        }
    }
    return PreviewWrapper()
}
