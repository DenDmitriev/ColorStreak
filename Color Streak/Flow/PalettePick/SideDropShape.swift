//
//  SideDropShape.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 05.06.2024.
//

import SwiftUI

struct SideDropShape: Shape {
    
    let axis: Edge
     
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        switch axis {
        case .top:
            break
        case .leading:
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            
            path.addQuadCurve(to: CGPoint(x: rect.maxX * 1/4, y: rect.maxY * 1/4), control: CGPoint(x: rect.minX, y: rect.maxY * 1/4))
            
            path.addArc(center: CGPoint(x: rect.midX/2, y: rect.midY),
                        radius: rect.midX / 2,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(90),
                        clockwise: false)
            
            path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY), control: CGPoint(x: rect.minX, y: rect.maxY * 3/4))
            
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        case .bottom:
            break
        case .trailing:
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            
            path.addQuadCurve(to: CGPoint(x: rect.maxX * 3/4, y: rect.maxY * 1/4), control: CGPoint(x: rect.maxX, y: rect.maxY * 1/4))
            
            path.addArc(center: CGPoint(x: rect.maxX * 3/4, y: rect.midY),
                        radius: rect.midX / 2,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(90),
                        clockwise: true)
            
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.maxX, y: rect.maxY * 3/4))
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
         
        return path
    }
}

#Preview {
    ZStack {
        Rectangle()
            .stroke(.secondary)
            .frame(width: 1, height: .infinity)
        
        Rectangle()
            .stroke(.secondary)
            .frame(width: 1, height: .infinity)
            .padding(.leading, -100)
        
        Rectangle()
            .stroke(.secondary)
            .frame(width: 1, height: .infinity)
            .padding(.leading, 200)
        
        Rectangle()
            .stroke(.secondary)
            .frame(width: .infinity, height: 1)
        
        Rectangle()
            .stroke(.secondary)
            .frame(width: .infinity, height: 1)
            .padding(.top, -100)
        
        Rectangle()
            .stroke(.secondary)
            .frame(width: .infinity, height: 1)
            .padding(.top, 200)
        
        SideDropShape(axis: .leading)
            .fill(.pink)
    }
    .frame(width: 400, height: 400)
    .border(.secondary)
}
