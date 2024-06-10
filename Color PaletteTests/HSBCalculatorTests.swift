//
//  HSBCalculatorTests.swift
//  dE CalculatorTests
//
//  Created by Denis Dmitriev on 29.05.2024.
//

import XCTest
@testable import Color_Palette

final class HSBCalculatorTests: XCTestCase {
    
    func testRGBRedtoHSB() {
        let color: CGColor = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
        let hsl = HSBCalculator.rgb2hsb(rgb: HSBCalculator.RGB(r: color.red, g: color.green, b: color.blue))
        
        XCTAssertEqual(hsl.h, 0)
        XCTAssertEqual(hsl.s, 1)
        XCTAssertEqual(hsl.b, 1)
    }
    
    func testRGBGreenToHSB() {
        let color: CGColor = CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1)
        let hsl = HSBCalculator.rgb2hsb(rgb: HSBCalculator.RGB(r: color.red, g: color.green, b: color.blue))
        
        XCTAssertEqual(hsl.h, 120)
        XCTAssertEqual(hsl.s, 1)
        XCTAssertEqual(hsl.b, 1)
    }
    
    func testRGBBlueToHSB() {
        let color: CGColor = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)
        let hsl = HSBCalculator.rgb2hsb(rgb: HSBCalculator.RGB(r: color.red, g: color.green, b: color.blue))
        
        XCTAssertEqual(hsl.h, 240)
        XCTAssertEqual(hsl.s, 1)
        XCTAssertEqual(hsl.b, 1)
    }
    
    func testRGBSomeToHSB() {
        let color: CGColor = CGColor(srgbRed: 120/255, green: 10/255, blue: 240/255, alpha: 1)
        let hsl = HSBCalculator.rgb2hsb(rgb: HSBCalculator.RGB(r: color.red, g: color.green, b: color.blue))
        
        XCTAssertEqual(hsl.h, 269, accuracy: 1)
        XCTAssertEqual(hsl.s, 0.96, accuracy: 0.1)
        XCTAssertEqual(hsl.b, 0.94, accuracy: 0.1)
    }
    
    func testRGBBlackToHSB() {
        let color: CGColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        let hsl = HSBCalculator.rgb2hsb(rgb: HSBCalculator.RGB(r: color.red, g: color.green, b: color.blue))
        
        XCTAssertEqual(hsl.h, 0)
        XCTAssertEqual(hsl.s, 0)
        XCTAssertEqual(hsl.b, 1)
    }
    
    func testRGBWhiteToHSB() {
        let color: CGColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        let hsl = HSBCalculator.rgb2hsb(rgb: HSBCalculator.RGB(r: color.red, g: color.green, b: color.blue))
        
        XCTAssertEqual(hsl.h, 0)
        XCTAssertEqual(hsl.s, 0)
        XCTAssertEqual(hsl.b, 0)
    }
    
    func testHSBtoRGBRed() {
        let hsb = HSB(hue: 0, saturation: 1, brightness: 1, alpha: 1)
        let rgb = HSBCalculator.hsb2rgb(hsb: HSBCalculator.HSB(h: hsb.hue360, s: hsb.saturation, b: hsb.brightness))
        let color = CGColor(srgbRed: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0)
        
        XCTAssertEqual(color.red, 1)
        XCTAssertEqual(color.blue, 0)
        XCTAssertEqual(color.green, 0)
    }
    
    func testHSBtoRGBGreen() {
        let hsb = HSB(hue: 120 / 360, saturation: 1, brightness: 1, alpha: 1)
        let rgb = HSBCalculator.hsb2rgb(hsb: HSBCalculator.HSB(h: hsb.hue360, s: hsb.saturation, b: hsb.brightness))
        let color = CGColor(srgbRed: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0)
        
        XCTAssertEqual(color.red, 0)
        XCTAssertEqual(color.green, 1)
        XCTAssertEqual(color.blue, 0)
    }
    
    func testHSBtoRGBBlue() {
        let hsb = HSB(hue: 240 / 360, saturation: 1, brightness: 1, alpha: 1)
        let rgb = HSBCalculator.hsb2rgb(hsb: HSBCalculator.HSB(h: hsb.hue360, s: hsb.saturation, b: hsb.brightness))
        let color = CGColor(srgbRed: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0)
        
        XCTAssertEqual(color.red, 0)
        XCTAssertEqual(color.green, 0)
        XCTAssertEqual(color.blue, 1)
    }
    
    func testHSBtoRGBSome() {
        let hsb = HSB(hue: 95 / 360, saturation: 0.5, brightness: 0.75, alpha: 1)
        let rgb = HSBCalculator.hsb2rgb(hsb: HSBCalculator.HSB(h: hsb.hue360, s: hsb.saturation, b: hsb.brightness))
        
        XCTAssertEqual(rgb.r, 135 / 255, accuracy: 0.1)
        XCTAssertEqual(rgb.g, 191 / 255, accuracy: 0.1)
        XCTAssertEqual(rgb.b, 96 / 255, accuracy: 0.1)
    }
    
    func testHSBtoRGBBlack() {
        let hsb = HSB(
            hue: Double(Int.random(in: 0...360) / 360),
            saturation: Double(Int.random(in: 0...100) / 100),
            brightness: 1,
            alpha: 1
        )
        let rgb = HSBCalculator.hsb2rgb(hsb: HSBCalculator.HSB(h: hsb.hue360, s: hsb.saturation, b: hsb.brightness))
        let color = CGColor(srgbRed: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0)
        
        XCTAssertEqual(color.red, 1)
        XCTAssertEqual(color.green, 1)
        XCTAssertEqual(color.blue, 1)
    }
    
    func testHSBtoRGBWhite() {
        let hsb = HSB(
            hue: Double(Int.random(in: 0...360) / 360),
            saturation: Double(Int.random(in: 0...100) / 100),
            brightness: 0,
            alpha: 1
        )
        let rgb = HSBCalculator.hsb2rgb(hsb: HSBCalculator.HSB(h: hsb.hue360, s: hsb.saturation, b: hsb.brightness))
        let color = CGColor(srgbRed: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0)
        
        XCTAssertEqual(color.red, 0)
        XCTAssertEqual(color.green, 0)
        XCTAssertEqual(color.blue, 0)
    }
    

}
