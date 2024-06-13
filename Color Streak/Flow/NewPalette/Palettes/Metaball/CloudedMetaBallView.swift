//
//  CloudedMetaBallView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 02.06.2024.
//

import SwiftUI

struct CloudedMetaBallView: View {
    @Binding var color: Color
    @State private var startAnimation = true
    @State var count: Int = 3
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 3.6, paused: false)) { _ in
            Canvas { context, size in
                context.addFilter(.alphaThreshold(min: 0.5, color: color))
                context.addFilter(.blur(radius: 30))
                
                context.drawLayer { ctx in
                    for index in Array(0...(count - 1)) {
                        if let resolvedView = context.resolveSymbol(id: index) {
                            ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                        }
                    }
                }
            } symbols: {
                ForEach(Array(0...(count - 1)), id: \.self) { index in
                    let width = Int.random(in: -180...180)
                    let height = Int.random(in: -240...240)
                    let offset = (startAnimation ? CGSize(width: width, height: height) : .zero)
                    CloudedRoundedRectangle(color, offset: offset)
                        .tag(index)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            startAnimation.toggle()
        }
    }
    
    private func CloudedRoundedRectangle(_ color: Color, offset: CGSize = .zero) -> some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(color)
            .frame(width: 120, height: 120)
            .offset(offset)
            .animation(.easeInOut(duration: 4), value: offset)
    }
}

#Preview {
    CloudedMetaBallView(color: .constant(.red))
        .preferredColorScheme(.dark)
}
