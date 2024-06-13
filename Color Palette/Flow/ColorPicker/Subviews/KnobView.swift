//
//  CursorCircle.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 25.05.2024.
//

import SwiftUI

struct KnobView: View {
    @Binding var color: Color
    
    @Environment(\.isEnabled) private var isEnabled
    
    var body: some View {
        Circle()
            .stroke(isEnabled ? Color.white : .clear, lineWidth: 2)
            .fill(isEnabled ? color : .clear)
            .shadow(color: .black.opacity(0.08), radius: 6, y: 4)
    }
}

#Preview {
    KnobView(color: .constant(.red))
}
