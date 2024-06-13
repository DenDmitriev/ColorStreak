//
//  LineView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 27.05.2024.
//

import SwiftUI

struct LineView : View {
    @Binding var start: CGPoint
    @Binding var end: CGPoint
    @State var color: Color
    @State var lineWidth: CGFloat
    @State private var offset: CGSize
    
    init(start: Binding<CGPoint>, end: Binding<CGPoint>, offset: CGSize = .zero, color: Color = .secondary, lineWidth: CGFloat = 1) {
        self._start = start
        self._end = end
        self.color = color
        self.lineWidth = lineWidth
        self.offset = offset
    }

    struct LineBetween : Shape {
        let point1: CGPoint
        let point2: CGPoint

        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: point1)
            path.addLine(to: point2)
            path.closeSubpath()
            return path
        }
    }

    private var targetPoint: CGPoint {
        CGPoint(
            x: end.x + offset.width,
            y: end.y + offset.height
        )
    }

    var body: some View {
        ZStack {
            LineBetween(
                point1: start,
                point2: targetPoint
            )
            .stroke(color, lineWidth: lineWidth)
                .offset(x: offset.width, y: offset.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation
                        }
                        .onEnded { _ in
                            end = targetPoint
                            offset = CGSize()
                        }
                )
        }
    }
}


#Preview {
    LineView(start: .constant(.init(x: 0, y: 0)), end: .constant(.init(x: 100, y: 100)))
}
