//
//  CircleStrokeButtonStyle.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 04.06.2024.
//

import SwiftUI

import SwiftUI

extension ButtonStyle where Self == CircleStrokeButtonStyle {
    static var circleStroked: CircleStrokeButtonStyle {
        .init()
    }
}

struct CircleStrokeButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    var isLightMode: Bool {
        colorScheme == .light
    }
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .font(.system(size: 24, weight: .semibold))
            .lineLimit(1)
            .frame(width: 32, height: 32)
            .padding(4)
            .foregroundStyle(.tint)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .background {
                Circle()
                    .stroke(.tint, lineWidth: 3)
                    .fill(.background.opacity(0.001))
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
            .buttonStyle(.circleStroked)
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
