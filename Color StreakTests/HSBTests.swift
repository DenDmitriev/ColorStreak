//
//  HSBTests.swift
//  dE CalculatorTests
//
//  Created by Denis Dmitriev on 19.05.2024.
//

import XCTest
@testable import Color_Streak

final class HSBTests: XCTestCase {

    func testHSBWhite() {
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
        let color = CGColor(colorSpace: colorSpace, components: [1,1,1,1])!
        let hsb = color.hsb
        XCTAssertEqual(hsb.hue, 0)
        XCTAssertEqual(hsb.saturation, 0)
        XCTAssertEqual(hsb.brightness, 1)
    }
    
    func testHSBBlack() {
        let color = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: [0,0,0,1])!
        let hsb = color.hsb
        XCTAssertEqual(hsb.hue, 0)
        XCTAssertEqual(hsb.saturation, 0)
        XCTAssertEqual(hsb.brightness, 0)
    }
    
    func testHSBGrayScale() {
        let color = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.genericGrayGamma2_2)!, components: [0.5 ,1])!
        let hsb = color.hsb
        XCTAssertEqual(hsb.hue, 0)
        XCTAssertEqual(hsb.saturation, 0)
        XCTAssertEqual(hsb.brightness, 0.5)
    }
    
    private enum Sample: CaseIterable {
        case red, green, blue
        var components: [CGFloat] {
            switch self {
            case .red:
                [1,0,0,1]
            case .green:
                [0,1,0,1]
            case .blue:
                [0,0,1,1]
            }
        }
        func color(colorSpace: CGColorSpace) -> CGColor {
            CGColor(colorSpace: colorSpace, components: self.components)!
        }
    }
    
    func testHSBsRGB() {
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
        let samples = Sample.allCases
        for sample in samples {
            let hsb = sample.color(colorSpace: colorSpace).hsb
            switch sample {
            case .red:
                XCTAssertEqual(hsb.hue, 0)
                XCTAssertEqual(hsb.saturation, 1)
                XCTAssertEqual(hsb.brightness, 1)
            case .green:
                XCTAssertEqual(hsb.hue, 120 / 360)
                XCTAssertEqual(hsb.saturation, 1)
                XCTAssertEqual(hsb.brightness, 1)
            case .blue:
                XCTAssertEqual(hsb.hue, 240 / 360)
                XCTAssertEqual(hsb.saturation, 1)
                XCTAssertEqual(hsb.brightness, 1)
            }
        }
    }
    
    func testHSBDeviceRGB() {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let samples = Sample.allCases
        for sample in samples {
            let hsb = sample.color(colorSpace: colorSpace).hsb
            switch sample {
            case .red:
                XCTAssertEqual(hsb.hue, 0)
                XCTAssertEqual(hsb.saturation, 1)
                XCTAssertEqual(hsb.brightness, 1)
            case .green:
                XCTAssertEqual(hsb.hue, 120 / 360)
                XCTAssertEqual(hsb.saturation, 1)
                XCTAssertEqual(hsb.brightness, 1)
            case .blue:
                XCTAssertEqual(hsb.hue, 240 / 360)
                XCTAssertEqual(hsb.saturation, 1)
                XCTAssertEqual(hsb.brightness, 1)
            }
        }
    }

}
