//
//  ImageRenderService.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import SwiftUI

enum ImageRenderServiceError: Error {
    case renderFailure
}

class ImageRenderService {
    
    enum Option {
        case border(color: UIColor)
    }
    
    // Создание штрих-кода с цветами из прямоугольников
    static func paletteImage(size: CGSize, colors: [UIColor], axis: Axis.Set, option: Option? = nil) throws -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let uiImage = renderer.image { ctx in
            let widthSegment = Int(size.width) / colors.count
            let remainder = size.width - CGFloat(widthSegment * colors.count)
            
            for (index, color) in colors.enumerated() {
                let rectangle = rect(size: size, axis: axis, widthSegment: widthSegment, index: index)
                
                ctx.cgContext.setFillColor(color.cgColor)
                
                ctx.cgContext.addRect(rectangle)
                ctx.cgContext.drawPath(using: .fill)
            }
            
            if remainder > 0, let lastColor = colors.last {
                let rectangleReminder = rectReminder(size: size, axis: axis, widthSegment: widthSegment, count: colors.count)
                ctx.cgContext.setFillColor(lastColor.cgColor)
                
                ctx.cgContext.addRect(rectangleReminder)
                ctx.cgContext.drawPath(using: .fill)
            }
        }
        
        return uiImage
    }
    
    static private func rect(size: CGSize, axis: Axis.Set, widthSegment: Int, index: Int) -> CGRect {
        let xOffset: Int
        let yOffset: Int
        let width: Int
        let height: Int
        switch axis {
        case .horizontal:
            xOffset = index * widthSegment
            yOffset = 0
            width = widthSegment
            height = Int(size.height)
        case .vertical:
            xOffset = 0
            yOffset = index * widthSegment
            width = Int(size.width)
            height = widthSegment
        default:
             return  .zero
        }
        let rectangle = CGRect(x: xOffset, y: yOffset, width: width, height: height)
        return rectangle
    }
    
    static private func rectReminder(size: CGSize, axis: Axis.Set, widthSegment: Int, count: Int) -> CGRect {
        let xOffset: Int
        let yOffset: Int
        let width: Int
        let height: Int
        switch axis {
        case .horizontal:
            xOffset = count * widthSegment
            yOffset = 0
            width = Int(size.width.rounded(.up)) - widthSegment * count
            height = Int(size.height)
        case .vertical:
            xOffset = 0
            yOffset = count * widthSegment
            width = Int(size.width)
            height = Int(size.height.rounded(.up)) - widthSegment * count
        default:
             return  .zero
        }
        let rectangle = CGRect(x: xOffset, y: yOffset, width: width, height: height)
        return rectangle
    }
}
