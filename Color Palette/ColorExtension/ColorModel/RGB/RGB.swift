//
//  RGB.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 17.05.2024.
//

import SwiftUI

public struct RGB {
    /// The red channel of the RGB color space as a value from 0 to 1.
    public let red: Double
    /// The green channel of the RGB color space as a value from 0 to 1.
    public let green: Double
    /// The blue channel of the RGB color space as a value from 0 to 1.
    public let blue: Double
    
    /// The red channel of the RGB color space as a value from 0 to 255.
    public var red255: Int {
        to255(red)
    }
    /// The green channel of the RGB color space as a value from 0 to 255.
    public var green255: Int {
        to255(green)
    }
    /// The blue channel of the RGB color space as a value from 0 to 255.
    public var blue255: Int {
        to255(blue)
    }
    
    private func to255(_ value: Double) -> Int {
        let normalized = max(min((value * 255).rounded(), 255), 0)
        return Int(normalized)
    }
}

extension RGB {
    /// Init RGB with channels in range 0..255.
    public init(red255: Int, green255: Int, blue255: Int) {
        self.red = max(min(Double(red255) / 255, 1), 0)
        self.green = max(min(Double(green255) / 255, 1), 0)
        self.blue = max(min(Double(blue255) / 255, 1), 0)
    }
}

extension RGB: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.red255 == rhs.red255 &&
        lhs.green255 == rhs.green255 &&
        lhs.blue255 == rhs.blue255
    }
    
    /// Сравнивает два цвета с погрешность в диапазоне каналов от 0 до 255.
    public func isEqual(with rgb: Self, accuracy: Int) -> Bool {
        (rgb.red255 - accuracy)...(rgb.red255 + accuracy) ~= self.red255 &&
        (rgb.green255 - accuracy)...(rgb.green255 + accuracy) ~= self.green255 &&
        (rgb.blue255 - accuracy)...(rgb.blue255 + accuracy) ~= self.blue255
    }
}

extension RGB: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(red)
        hasher.combine(green)
        hasher.combine(blue)
    }
}

extension RGB {
    public init(color: Color) {
        let cgColor = UIColor(color).cgColor
        let (red, green, blue) = Self.components(cgColor.components)
        
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    public init(cgColor: CGColor) {
        let (red, green, blue) = Self.components(cgColor.components)
        
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    static private func components(_ components: [CGFloat]?) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        guard let components else {
            return (0, 0, 0)
        }
        if components.count >= 3 {
            return (components[0], components[1], components[2])
        } else {
            return (components[0], components[0], components[0])
        }
    }
}

extension RGB: CustomStringConvertible {
    public var description: String {
        "RGB(\(red255), \(green255), \(blue255))"
    }
}

extension Color {
    public var rgb: RGB {
        RGB(color: self)
    }
    
    init(rgb: RGB) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue)
    }
}
