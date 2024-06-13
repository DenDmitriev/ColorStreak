//
//  TemperatureColorCalculator.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 06.06.2024.
//
// From http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/

import Foundation

struct TemperatureColorCalculator {
    
    /// Get RGB values from temperature kelvin value
    ///
    /// - Parameters:
    ///     - kelvin: Temperature range from 1000 K to 40000 K.
    /// - Returns: RGB channel by `Int` in range 0...255.
    static func temperatureToRGB(kelvin: Int) -> (r: Int, g: Int, b: Int) {
        let temp = Double(kelvin) / 100
        var red: Double, green: Double, blue: Double
        
        if temp <= 66 {
            red = 255
            green = temp
            green = 99.4708025861 * log(green) - 161.1195681661
            
            if temp <= 19 {
                blue = 0
            } else {
                blue = temp - 10
                blue = 138.5177312231 * log(blue) - 305.0447927307
            }
        } else {
            red = temp - 60
            red = 329.698727446 * pow(red, -0.1332047592)
            green = temp - 60
            green = 288.1221695283 * pow(green, -0.0755148492)
            blue = 255
        }
        
        return (
            r: clamp(Int(red), min: 0, max: 255),
            g: clamp(Int(green), min: 0, max: 255),
            b: clamp(Int(blue), min: 0, max: 255)
        )
    }
    
    static private func clamp(_ x: Int, min: Int, max: Int) -> Int {
        if x < min { return min }
        if x > max { return max }
        return x
    }
    
    /// Get Temperature Kelvin value from RGB values
    ///
    /// - Parameters:
    ///     - rgb: Chanel value range from 0 to 255.
    /// - Returns: Kelvin by`Int` in range 1000K...40000K.
    static func rgbToTemperature(rgb: (red: Int, green: Int, blue: Int)) -> Int {
        var kelvin: Double = 0
        var min: Double = 1000
        var max: Double = 40000

        while max - min > 0.4 {
            kelvin = (max + min) / 2.0
            let (red, _, blue) = temperatureToRGB(kelvin: Int(kelvin))
            if Double(blue) / Double(red) >= Double(rgb.blue) / Double(rgb.red) {
                max = kelvin
            } else {
                min = kelvin
            }
        }

        return Int(round(kelvin))
    }

}
