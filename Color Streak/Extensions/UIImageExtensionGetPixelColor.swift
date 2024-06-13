//
//  UIImageExtensionGetPixelColor.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 04.06.2024.
//

import SwiftUI

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension UIImage {
    func getColors() -> [CGPoint: UIColor] {
        guard let cgImage = self.cgImage,
              let dataProvider = cgImage.dataProvider
        else { return [:] }
        
        let pixelData = dataProvider.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var channels = 4
        if UIImage.grayColorSpaces.contains(cgImage.colorSpace) {
            channels = 2
        }
        
        let resolution = CGSize(width: cgImage.width, height: cgImage.height)
        let area = Int(resolution.width * resolution.height)
        
        var colorsOnImage = [CGPoint: UIColor]()
        colorsOnImage.reserveCapacity(area)
        
        for yCoordonate in 0 ..< cgImage.height {
            for xCoordonate in 0 ..< cgImage.width {
                let index = (cgImage.width * yCoordonate + xCoordonate) * channels
                if channels == 4 {
                    let red = CGFloat(data[index]) / 255
                    let green = CGFloat(data[index + 1]) / 255
                    let blue = CGFloat(data[index + 2]) / 255
                    let alpha = CGFloat(data[index + 3]) / 255
                    let pixelColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                    let point = CGPoint(x: xCoordonate, y: yCoordonate)
                    colorsOnImage[point] = pixelColor
                } else if channels == 2 {
                    let gray = CGFloat(data[index]) / 255
                    let alpha = CGFloat(data[index + 1]) / 255
                    let pixelColor = UIColor(red: gray, green: gray, blue: gray, alpha: alpha)
                    let point = CGPoint(x: xCoordonate, y: yCoordonate)
                    colorsOnImage[point] = pixelColor
                }
            }
        }
        
        return colorsOnImage
    }
    
    func getColor(point: CGPoint) -> UIColor {
        guard let cgImage = self.cgImage,
              let dataProvider = cgImage.dataProvider
        else { return .clear }
        
        let pixelData = dataProvider.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let width = Int(size.width)
        
        if UIImage.grayColorSpaces.contains(cgImage.colorSpace) {
            let channels = 2
            let pixelIndex = (width * Int(point.y) + Int(point.x)) * channels
            
            let g = CGFloat(data[pixelIndex]) / 255
            let a = CGFloat(data[pixelIndex + 1]) / 255
            
            return UIColor(red: g, green: g, blue: g, alpha: a)
        } else {
            let channels = 4
            let pixelIndex = (width * Int(point.y) + Int(point.x)) * channels
            
            let r = CGFloat(data[pixelIndex]) / 255
            let g = CGFloat(data[pixelIndex + 1]) / 255
            let b = CGFloat(data[pixelIndex + 2]) / 255
            let a = CGFloat(data[pixelIndex + 3]) / 255
            
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }
        
    }
    
    private static var grayColorSpaces: [CGColorSpace?] = [
        CGColorSpace(name: CGColorSpace.genericGrayGamma2_2),
        CGColorSpace(name: CGColorSpace.linearGray),
        CGColorSpace(name: CGColorSpace.extendedGray),
        CGColorSpace(name: CGColorSpace.extendedLinearGray),
    ]
}
