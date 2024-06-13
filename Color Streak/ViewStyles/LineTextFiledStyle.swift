//
//  LineTextFiledStyle.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 02.06.2024.
//

import SwiftUI

extension TextFieldStyle where Self == LineTextFiledStyle {
    static func line(color: Color = .primary) -> LineTextFiledStyle { .init(color: color) }
}

struct LineTextFiledStyle: TextFieldStyle {
    let color: Color
    private let height: CGFloat = 3
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(alignment: .bottom, content: {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color)
                    .frame(height: height)
            })
    }
}

#Preview {
    TextField("Filed", text: .constant(""))
        .textFieldStyle(.line(color: .primary))
        .padding()
}
