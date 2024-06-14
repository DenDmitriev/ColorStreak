//
//  CMYKCalculatorTests.swift
//  dE CalculatorTests
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import XCTest
@testable import Color_Streak
import SwiftUI

final class CMYKCalculatorTests: XCTestCase {
    
    func testRGBToCMYKRed() {
        let cmyk = CMYKCalculator.rgbToCmyk(rgb: CMYKCalculator.RGB(r: 1, g: 0, b: 0))
        
        XCTAssertEqual(cmyk.c, 0)
        XCTAssertEqual(cmyk.m, 1)
        XCTAssertEqual(cmyk.y, 1)
        XCTAssertEqual(cmyk.k, 0)
    }
    
    func testRGBToCMYKGreen() {
        let cmyk = CMYKCalculator.rgbToCmyk(rgb: CMYKCalculator.RGB(r: 0, g: 1, b: 0))
        
        XCTAssertEqual(cmyk.c, 1)
        XCTAssertEqual(cmyk.m, 0)
        XCTAssertEqual(cmyk.y, 1)
        XCTAssertEqual(cmyk.k, 0)
    }
    
    func testRGBToCMYKBlue() {
        let cmyk = CMYKCalculator.rgbToCmyk(rgb: CMYKCalculator.RGB(r: 0, g: 0, b: 1))
        
        XCTAssertEqual(cmyk.c, 1)
        XCTAssertEqual(cmyk.m, 1)
        XCTAssertEqual(cmyk.y, 0)
        XCTAssertEqual(cmyk.k, 0)
    }
    
    func testRGBToCMYKSome() {
        let cmyk = CMYKCalculator.rgbToCmyk(rgb: CMYKCalculator.RGB(r: 10 / 255, g: 120 / 255, b: 245 / 255))
        
        XCTAssertEqual(cmyk.c, 0.9592, accuracy: 0.1)
        XCTAssertEqual(cmyk.m, 0.5102, accuracy: 0.1)
        XCTAssertEqual(cmyk.y, 0.0000, accuracy: 0.1)
        XCTAssertEqual(cmyk.k, 0.0392, accuracy: 0.1)
    }
    
    func testRGBToCMYKWhite() {
        let cmyk = CMYKCalculator.rgbToCmyk(rgb: CMYKCalculator.RGB(r: 0, g: 0, b: 0))
        
//        XCTAssertEqual(cmyk.c, 0)
//        XCTAssertEqual(cmyk.m, 0)
//        XCTAssertEqual(cmyk.y, 0)
        XCTAssertEqual(cmyk.k, 1)
    }
    
    func testRGBToCMYKBlack() {
        let cmyk = CMYKCalculator.rgbToCmyk(rgb: CMYKCalculator.RGB(r: 1, g: 1, b: 1))
        
        XCTAssertEqual(cmyk.c, 0)
        XCTAssertEqual(cmyk.m, 0)
        XCTAssertEqual(cmyk.y, 0)
        XCTAssertEqual(cmyk.k, 0)
    }
    
    func testCMYKToRGBCyan() {
        let rgb = CMYKCalculator.cmykToRgb(cmyk: CMYKCalculator.CMYK(c: 1, m: 0, y: 0, k: 0))
        
        XCTAssertEqual(rgb.r, 0)
        XCTAssertEqual(rgb.b, 1)
        XCTAssertEqual(rgb.g, 1)
    }
    
    func testCMYKToRGBMagenta() {
        let rgb = CMYKCalculator.cmykToRgb(cmyk: CMYKCalculator.CMYK(c: 0, m: 1, y: 0, k: 0))
        
        XCTAssertEqual(rgb.r, 1)
        XCTAssertEqual(rgb.g, 0)
        XCTAssertEqual(rgb.b, 1)
    }
    
    func testCMYKToRGBYellow() {
        let rgb = CMYKCalculator.cmykToRgb(cmyk: CMYKCalculator.CMYK(c: 0, m: 0, y: 1, k: 0))
        
        XCTAssertEqual(rgb.r, 1)
        XCTAssertEqual(rgb.g, 1)
        XCTAssertEqual(rgb.b, 0)
    }
    
    func testCMYKToRGBKeyBlack() {
        func random() -> Double {
            Double(Int.random(in: 0...100)) / 100
        }
        let rgb = CMYKCalculator.cmykToRgb(cmyk: CMYKCalculator.CMYK(c: random(), m: random(), y: random(), k: 1))
        
        XCTAssertEqual(rgb.r, 0)
        XCTAssertEqual(rgb.g, 0)
        XCTAssertEqual(rgb.b, 0)
    }
    
    func testCMYKToRGBKeyWhite() {
        let rgb = CMYKCalculator.cmykToRgb(cmyk: CMYKCalculator.CMYK(c: 0, m: 0, y: 0, k: 0))
        
        XCTAssertEqual(rgb.r, 1)
        XCTAssertEqual(rgb.g, 1)
        XCTAssertEqual(rgb.b, 1)
    }
    
    func testCMYKToRGBKeySome() {
        let rgb = CMYKCalculator.cmykToRgb(cmyk: CMYKCalculator.CMYK(c: 50 / 100, m: 10 / 100, y: 90 / 100, k: 30 / 100))
        
        XCTAssertEqual(rgb.r, 89 / 255, accuracy: 0.1)
        XCTAssertEqual(rgb.g, 161 / 255, accuracy: 0.1)
        XCTAssertEqual(rgb.b, 18 / 255, accuracy: 0.1)
    }
    
    func testCMYKToCMYK() {
        let sourceCMYK = CMYK(cyan: 0.5, magenta: 0.1, yellow: 0.8, black: 0)
        let color = Color(cmyk: sourceCMYK)
        let resultCMYK = color.cmyk
        
        XCTAssertEqual(color.rgb.red, 128 / 255, accuracy: 0.1)
        XCTAssertEqual(color.rgb.green, 230 / 255, accuracy: 0.1)
        XCTAssertEqual(color.rgb.blue, 51 / 255, accuracy: 0.1)
        
        XCTAssertEqual(sourceCMYK.cyan, resultCMYK.cyan, accuracy: 0.1)
        XCTAssertEqual(sourceCMYK.magenta, resultCMYK.magenta, accuracy: 0.1)
        XCTAssertEqual(sourceCMYK.yellow, resultCMYK.yellow, accuracy: 0.1)
        XCTAssertEqual(sourceCMYK.key, resultCMYK.key, accuracy: 0.1)
    }

}
