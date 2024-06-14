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
    
    // https://stackoverflow.com/questions/3284185/get-pixel-color-of-uiimage
    func getColor(point: CGPoint) -> UIColor {
        guard let cgImage = self.cgImage,
              let dataProvider = cgImage.dataProvider,
              let layout = cgImage.bitmapInfo.componentLayout
        else { return .clear }
        
        let pixelData = dataProvider.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        guard !UIImage.grayColorSpaces.contains(cgImage.colorSpace)
        else {
            let channels = 2
            let width = Int(size.width)
            let pixelIndex = (width * Int(point.y) + Int(point.x)) * channels
            
            let g = CGFloat(data[pixelIndex]) / 255
            let a = CGFloat(data[pixelIndex + 1]) / 255
            
            return UIColor(red: g, green: g, blue: g, alpha: a)
        }
        
        let x = Int(point.x)
        let y = Int(point.y)
        let w = Int(self.size.width)
        let h = Int(self.size.height)
        let index = w * y + x
        let numBytes = CFDataGetLength(pixelData)
        let numComponents = layout.count
        
        if numBytes != w * h * numComponents {
            NSLog("Unexpected size: \(numBytes) != \(w)x\(h)x\(numComponents)")
            return .clear
        }
        let isAlphaPremultiplied = cgImage.bitmapInfo.isAlphaPremultiplied
        switch numComponents {
        case 1:
            return UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(data[index])/255.0)
        case 3:
            let c0 = CGFloat((data[3*index])) / 255
            let c1 = CGFloat((data[3*index+1])) / 255
            let c2 = CGFloat((data[3*index+2])) / 255
            if layout == .bgr {
                return UIColor(red: c2, green: c1, blue: c0, alpha: 1.0)
            }
            return UIColor(red: c0, green: c1, blue: c2, alpha: 1.0)
        case 4:
            let c0 = CGFloat((data[4*index])) / 255
            let c1 = CGFloat((data[4*index+1])) / 255
            let c2 = CGFloat((data[4*index+2])) / 255
            let c3 = CGFloat((data[4*index+3])) / 255
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            switch layout {
            case .abgr:
                a = c0; b = c1; g = c2; r = c3
            case .argb:
                a = c0; r = c1; g = c2; b = c3
            case .bgra:
                b = c0; g = c1; r = c2; a = c3
            case .rgba:
                r = c0; g = c1; b = c2; a = c3
            default:
                break
            }
            if isAlphaPremultiplied && a > 0 {
                r = r / a
                g = g / a
                b = b / a
            }
            return UIColor(red: r, green: g, blue: b, alpha: a)
        default:
            return .clear
        }
    }
    
    private static var grayColorSpaces: [CGColorSpace?] = [
        CGColorSpace(name: CGColorSpace.genericGrayGamma2_2),
        CGColorSpace(name: CGColorSpace.linearGray),
        CGColorSpace(name: CGColorSpace.extendedGray),
        CGColorSpace(name: CGColorSpace.extendedLinearGray),
    ]
}
