//
//  PrimaryActionButtonStyle.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 02.06.2024.
//
import SwiftUI

extension ButtonStyle where Self == PrimaryActionButtonStyle {
    static var primaryAction: PrimaryActionButtonStyle {
        .init()
    }
}

struct PrimaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let role = configuration.role ?? .cancel
        return configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background {
                switch role {
                case .destructive:
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.red, lineWidth: 2)
                default:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.tint)
                }
                
            }
            .foregroundStyle(role == .destructive ? .red : .white)
            .font(.system(size: 18, weight: .bold))
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview(body: {
    VStack {
        Button(role: .destructive) {
            print(#function)
        } label: {
            Label("Delete", systemImage: "xmark")
        }
        
        Button {
            print(#function)
        } label: {
            HStack {
                Text("Next")
                Image(systemName: "arrow.right")
            }
        }
    }
    .buttonStyle(.primaryAction)
})
