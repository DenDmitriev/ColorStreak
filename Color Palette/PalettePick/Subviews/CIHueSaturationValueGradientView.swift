//
//  CIHueSaturationValueGradientView.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 27.05.2024.
//

import SwiftUI

/// This UIViewRepresentable uses `CIHueSaturationValueGradient` to draw a circular gradient with the RGB colour space as a CIFilter.
struct CIHueSaturationValueGradientView: UIViewRepresentable {
    /// Color Space for Wheel
    var colorSpace: CGColorSpace?
    
    /// Radius to draw
    var radius: CGFloat
    
    /// The brightness/value of the wheel.
    @Binding var brightness: CGFloat
    
    /// Image view that will hold the rendered CIHueSaturationValueGradient.
    let imageView = UIImageView()
    
    func makeUIView(context: Context) -> UIImageView {
        /// Render CIHueSaturationValueGradient and set it to the ImageView that will be returned.
        imageView.image = renderFilter()
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        /// When the view updates eg. brightness changes, a new CIHueSaturationValueGradient will be generated.
        uiView.image = nil
        uiView.image = renderFilter()
    }
    
    /// Generate the CIHueSaturationValueGradient and output it as a UIImage.
    func renderFilter() -> UIImage {
        let filter = CIFilter(name: "CIHueSaturationValueGradient", parameters: [
            "inputColorSpace": colorSpace ?? CGColorSpaceCreateDeviceRGB(),
            "inputDither": 0,
            "inputRadius": radius,
            "inputSoftness": 0,
            "inputValue": brightness
        ])!
        
        /// Output as UIImageView
        let image = UIImage(ciImage: filter.outputImage!)
        return image
    }
}

struct CIHueSaturationValueGradientView_Previews: PreviewProvider {
    static var previews: some View {
        CIHueSaturationValueGradientView(radius: 350, brightness: .constant(1))
            .frame(width: 350, height: 350)
    }
}
