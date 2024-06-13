//
//  CGColorExtensionConverters.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 18.05.2024.
//

import CoreGraphics.CGColor


// sRGB Converter
extension CGColor {
    // MARK: - Public
    
    /// The red (R) channel of the RGB color space as a value from 0 to 1.
    public var red: CGFloat {
        guard components?.count == 4 else { return components?[0] ?? 0 }
        return components?[0] ?? 0
    }
    
    /// The green (G) channel of the RGB color space as a value from 0 to 1.
    public var green: CGFloat {
        guard components?.count == 4 else { return components?[0] ?? 0 }
        return components?[1] ?? 0
    }
    
    /// The blue (B) channel of the RGB color space as a value from 0 to 1.
    public var blue: CGFloat {
        guard components?.count == 4 else { return components?[0] ?? 0 }
        return components?[2] ?? 0
    }
    
    // MARK: Internal
    /// The red (R) channel of the RGB color space as a value from 0 to 255.
    var red255: CGFloat {
        (self.red * 255)
    }
    
    /// The green (G) channel of the RGB color space as a value from 0 to 255.
    var green255: CGFloat {
        (self.green * 255)
    }
    
    /// The blue (B) channel of the RGB color space as a value from 0 to 255.
    var blue255: CGFloat {
        (self.blue * 255)
    }
    
    var rgb: RGB {
        return RGB(red: self.red, green: self.green, blue: self.blue)
    }
}
