//
//  Triangle.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 30.05.2024.
//

import SwiftUI

struct Triangle: Shape {
    private var firstPointX: CGFloat = 0
    private var firstPointY: CGFloat = 0
    private var secondPointX: CGFloat = 0.5
    private var secondPointY: CGFloat = 1
    private var thirdPointX: CGFloat = 1
    private var thirdPointY: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: self.firstPointX * rect.width, y: self.firstPointY * rect.height))
        path.addLine(to: CGPoint(x: self.secondPointX * rect.width, y: self.secondPointY * rect.height))
        path.addLine(to: CGPoint(x: self.thirdPointX * rect.width, y: self.thirdPointY * rect.height))
        path.addLine(to: CGPoint(x: self.firstPointX * rect.width, y: self.firstPointY * rect.height))
        
        return path
    }
    
    
}

#Preview(body: {
    Triangle()
})
