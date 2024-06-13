//
//  SingleColorView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 28.05.2024.
//

import SwiftUI

struct SingleColorView: View {
    @State var color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
            .ignoresSafeArea()
    }
}

#Preview {
    SingleColorView(color: .yellow)
}
