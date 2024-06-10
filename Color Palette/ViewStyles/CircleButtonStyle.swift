//
//  CircleButtonStyle.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 28.05.2024.
//

import SwiftUI

extension ButtonStyle where Self == IconButtonStyle {
    static var circle: IconButtonStyle {
        .init()
    }
}

struct IconButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    var isLightMode: Bool {
        colorScheme == .light
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let role = configuration.role ?? .cancel
        return configuration.label
            .font(.system(size: 24, weight: .semibold))
            .lineLimit(1)
            .frame(width: 32, height: 32)
            .padding(4)
            .foregroundStyle(role == .destructive ? AnyShapeStyle(.appBackground) : isLightMode ? AnyShapeStyle(.appBackground) : AnyShapeStyle(.tint))
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .background {
                switch role {
                case .destructive:
                    Circle()
                        .fill(.appRed)
                default:
                    Circle()
                        .fill(isLightMode ? AnyShapeStyle(.tint): AnyShapeStyle(.appPrimary))
                }
                
            }
    }
}

#Preview(body: {
    struct PreviewWrapper: View {
        var body: some View {
            HStack(spacing: 24) {
                Button(role: .destructive) {
                    print(#function)
                } label: {
                    Image(systemName: "minus")
                }
                
                Button {
                    print(#function)
                } label: {
                    Image(systemName: "plus")
                }
                
                Button {
                    print(#function)
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
            .buttonStyle(.circle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.background)
        }
    }
    
    return VStack {
        PreviewWrapper()
            .environment(\.colorScheme, .light)
        
        PreviewWrapper()
            .environment(\.colorScheme, .dark)
    }
})
