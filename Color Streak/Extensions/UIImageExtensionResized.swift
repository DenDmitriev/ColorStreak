//
//  UIImageExtensionResized.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 05.06.2024.
//

import SwiftUI

extension UIImage {
    func resizeImage(width dimension: CGFloat, opaque: Bool = false, contentMode: ContentMode = .fit) -> UIImage? {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
        case .fit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        let rect: CGRect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: rect.size, format: renderFormat)
            newImage = renderer.image {
                context in
                self.draw(in: rect)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        guard let newData = newImage.pngData() else { return nil }
        
        return UIImage(data: newData)
    }
}

