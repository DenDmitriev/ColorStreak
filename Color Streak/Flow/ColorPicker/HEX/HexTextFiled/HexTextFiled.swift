//
//  HexTextFiled.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 28.05.2024.
//

import SwiftUI

struct HexTextFiled: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    let formatter: HexFormatter = .init()
    
    var body: some View {
        TextField(value: $text, formatter: formatter) {
            Text("#\(text)")
                .foregroundStyle(.white.opacity(0.7))
        }
        .font(.system(.title3, design: .monospaced))
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
        .focused($isFocused)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                ForEach(["A", "B", "C", "D", "E", "F"], id: \.self) { key in
                    Button(key) {
                        text.append(key)
                    }
                }
                .tint(.primary)
                
                Spacer()
                
                Button("Done") {
                    isFocused = false
                    let formatted = formatter.string(for: text) ?? ""
                    text = formatted
                }
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var text: String = "ABC000"
        var body: some View {
            HexTextFiled(text: $text)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    return PreviewWrapper()
        .padding()
}
