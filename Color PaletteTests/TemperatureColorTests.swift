//
//  TemperatureColorTests.swift
//  Color PaletteTests
//
//  Created by Denis Dmitriev on 06.06.2024.
//

import XCTest
import SwiftUI
@testable import Color_Palette

final class TemperatureColorTests: XCTestCase {
    
    static let kelvinDict: [Int: (red: Int, green: Int, blue: Int)] = [
        2700: (255, 169, 87),
        3200: (255, 187, 120),
        3600: (255, 199, 143),
        4000: (255, 209, 163),
        4400: (255, 217, 182),
        4800: (255, 225, 198),
        5200: (255, 232, 213),
        5600: (255, 238, 227),
        6000: (255, 243, 239),
        6500: (255, 249, 253),
       ]
    
    func testTempWarmToRGB() {
        let kelvin = 2700
        let (red, green, blue) = TemperatureColorCalculator.temperatureToRGB(kelvin: kelvin)
        
        let expectation = Self.kelvinDict[kelvin]!
        
        XCTAssertEqual(red, expectation.red, accuracy: 3)
        XCTAssertEqual(green, expectation.green, accuracy: 3)
        XCTAssertEqual(blue, expectation.blue, accuracy: 3)
    }
    
    func testTempColdToRGB() {
        let kelvin = 5600
        let (red, green, blue) = TemperatureColorCalculator.temperatureToRGB(kelvin: kelvin)
        
        let expectation = Self.kelvinDict[kelvin]!
        
        XCTAssertEqual(red, expectation.red, accuracy: 3)
        XCTAssertEqual(green, expectation.green, accuracy: 3)
        XCTAssertEqual(blue, expectation.blue, accuracy: 3)
    }
    
    func testTempWhiteToRGB() {
        let kelvin = 6500
        let (red, green, blue) = TemperatureColorCalculator.temperatureToRGB(kelvin: kelvin)
        
        let expectation = Self.kelvinDict[kelvin]!
        
        XCTAssertEqual(red, expectation.red, accuracy: 3)
        XCTAssertEqual(green, expectation.green, accuracy: 6)
        XCTAssertEqual(blue, expectation.blue, accuracy: 3)
    }
    
    func testRGBWarmToTemp() {
        let kelvin = 2700
        let rgb = Self.kelvinDict[kelvin]!
        
        let resultKelvin = TemperatureColorCalculator.rgbToTemperature(rgb: rgb)
        
        XCTAssertEqual(kelvin, resultKelvin, accuracy: 5)
    }
    
    func testRGBColdToTemp() {
        let kelvin = 5600
        let rgb = Self.kelvinDict[kelvin]!
        
        let resultKelvin = TemperatureColorCalculator.rgbToTemperature(rgb: rgb)
        
        XCTAssertEqual(kelvin, resultKelvin, accuracy: 100)
    }
    
    func testRGBWhiteToTemp() {
        let kelvin = 6500
        let rgb = Self.kelvinDict[kelvin]!
        
        let resultKelvin = TemperatureColorCalculator.rgbToTemperature(rgb: rgb)
        
        XCTAssertEqual(kelvin, resultKelvin, accuracy: 101)
    }
}
