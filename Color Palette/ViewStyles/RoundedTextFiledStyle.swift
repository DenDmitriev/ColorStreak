//
//  RoundedTextFiledStyle.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
//

import SwiftUI

extension TextFieldStyle where Self == RoundedTextFiledStyle {

    /// A text field style with rounded border.
    static func rounded(cornerRadius: CGFloat = 12) -> RoundedTextFiledStyle { .init(cornerRadius: cornerRadius) }
}

struct RoundedTextFiledStyle: TextFieldStyle {
    let cornerRadius: CGFloat
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(.regularMaterial)
            .cornerRadius(cornerRadius)
    }
}

#Preview {
    VStack {
        TextField("Filed", text: .constant(""))
            .textFieldStyle(.rounded(cornerRadius: 8))
            .padding()
        
        TextField("Filed", text: .constant("Text"))
            .textFieldStyle(.rounded(cornerRadius: 8))
            .padding()
    }
    .background {
        Color.pink
    }
}
