//
//  ContrastResultView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 08.06.2024.
//

import SwiftUI

struct ContrastResultView: View {
    
    @Binding var contrast: ContrastWCAG?
    
    let columns = [GridItem(.flexible(minimum: 100), alignment: .leading),
                   GridItem(.fixed(70), alignment: .leading),
                   GridItem(.fixed(70), alignment: .leading)]
    
    var body: some View {
        switch contrast {
        case .some(let contrast):
            LazyVGrid(columns: columns) {
                Group {
                    Text("ELEMENT")
                    Text("AA")
                    Text("AAA")
                }
                .font(.headline)
                .foregroundStyle(.secondary)
                
                Group {
                    Text("Normal text")
                    ResultView(contrast: contrast, compliance: .AA, for: .normalText)
                    ResultView(contrast: contrast, compliance: .AAA, for: .normalText)
                    
                    Text("Large text")
                    ResultView(contrast: contrast, compliance: .AA, for: .largeText)
                    ResultView(contrast: contrast, compliance: .AAA, for: .largeText)
                    
                    Text("UI components")
                    ResultView(contrast: contrast, compliance: .AA, for: .uiComponents)
                    ResultView(contrast: contrast, compliance: .AAA, for: .uiComponents)
                }
                .font(.system(size: 18 ,weight: .regular))
            }
        case .none:
            placeholder
        }
    }
    
    private func ResultView(contrast: ContrastWCAG, compliance: ContrastWCAG.Compliance, for element: ContrastWCAG.Compliance.Element) -> some View {
        let result = contrast.checker(compliance: compliance, for: element)
        return Text(result ? "Pass" : "Fail")
            .font(.system(size: 18 ,weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background {Capsule().fill(result ? .green : .red) }
            
    }
    
    private var placeholder: some View {
        Text("No colors")
            .font(.system(size: 24, weight: .semibold))
            .foregroundStyle(.secondary)
    }
}

#Preview {
    ContrastResultView(contrast: .constant(ContrastWCAG(foreground: Color.pink, background: Color.black)))
}
