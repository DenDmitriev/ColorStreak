//
//  ContrastShapeView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 08.06.2024.
//

import SwiftUI

struct ContrastShapeView: View {
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                uiElement(systemName: "heart.fill")
                uiElement(systemName: "person.fill")
                uiElement(systemName: "bookmark.fill")
                uiElement(systemName: "checkmark.circle.fill")
            }
        }
    }
    
    private func uiElement(systemName: String) -> some View {
        Image(systemName: systemName)
            .frame(maxWidth: .infinity)
            .font(.system(size: 24))
    }
}

#Preview {
    ContrastShapeView()
}
