//
//  ShimmerEffectView.swift
//  Color Streak
//
//  Created by Denis Dmitriev on 17.06.2024.
//

import SwiftUI

import SwiftUI

struct ShimmerEffectView: View {
    
    enum Style {
        case gray, primary, custom(colors: [Color])
        
        var colors: [Color] {
            switch self {
            case .gray:
                [Color(uiColor: .gray), Color(uiColor: .lightGray), Color(uiColor: .gray)]
            case .primary:
                [Color(uiColor: .tintColor), .secondary, Color(uiColor: .tintColor)]
            case .custom(let colors):
                colors
            }
        }
    }
    @State var style: Style
    @State var animation: Bool
    @State private var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
    @State private var endPoint: UnitPoint = .init(x: 0, y: -0.2)
    
    init(style: Style = .gray, animation: Bool = true) {
        self.style = style
        self.animation = animation
    }
    
    var body: some View {
        LinearGradient(colors: style.colors, startPoint: startPoint, endPoint: endPoint)
            .onAppear {
                if animation {
                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                        startPoint = .init(x: 1, y: 1)
                        endPoint = .init(x: 2.2, y: 2.2)
                    }
                }
            }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            HStack {
                ShimmerEffectView(style: .primary)
                    .clipShape(Circle())
                    .frame(width: 100)
                
                VStack {
                    ShimmerEffectView()
                        .cornerRadius(16)
                        .frame(height: 32)
                    
                    ShimmerEffectView()
                        .cornerRadius(16)
                        .frame(height: 64)
                }
            }
            
            ShimmerEffectView()
                .cornerRadius(16)
                .frame(height: 128)
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}

